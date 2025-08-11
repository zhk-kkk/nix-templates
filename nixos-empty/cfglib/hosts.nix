{
  cfglib,
  inputs,
  ...
}: let
  outputs = inputs.self.outputs;
  lib = inputs.nixpkgs.lib;
in {
  # Generate nixosConfigurations.
  mkHosts = hostDescriptions: (
    lib.listToAttrs (
      builtins.map
      (hostDesc: {
        name = hostDesc.hostname;
        value = lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            cfglib = cfglib.scopes.configuration;
          };
          modules =
            [
              # Default configuration options
              {
                networking.hostName = hostDesc.hostname;
                nixpkgs.overlays = builtins.attrValues outputs.overlays;
                nix.settings.experimental-features = ["nix-command" "flakes"];
              }

              # The main configuration file
              hostDesc.path
            ]
            ++
            # Nixos modules
            (cfglib.mkModules [
              {
                path = outputs.modules.nixos + "/features";
                namespace = "";
              }
              {
                path = outputs.modules.nixos + "/bundles";
                namespace = "bundles";
              }
              {
                path = outputs.modules.nixos + "/services";
                namespace = "services";
              }
            ]);
        };
      })
      hostDescriptions
    )
  );
}
