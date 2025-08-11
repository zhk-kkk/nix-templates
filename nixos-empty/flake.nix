{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    cfglib = import ./cfglib/default.nix {inherit inputs;};
  in {
    overlays = import ./overlays {inherit inputs;};
    modules.nixos = ./modules/nixos;
    modules.homeManager = ./modules/home-manager;

    # Add your configurations as follows:
    # nixosConfigurations = cfglib.mkHosts [
    #   {
    #     path = ./hosts/example-configuration;
    #     hostname = "example-configuration";
    #   }
    # ];

    # Use `nix develop` or `nix shell` to bootstrap nix with flakes enabled.
    devShells = cfglib.forAllSystems (
      system:
        import ./shell.nix {pkgs = cfglib.pkgsFor system;}
    );
  };
}
