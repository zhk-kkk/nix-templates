{inputs}: let
  cfglib = (import ./default.nix) {inherit inputs;};
  outputs = inputs.self.outputs;
  lib = inputs.nixpkgs.lib;
in {
    # Scopes of functions passed to particular parts of the configurations
    scopes = {
      common = {
        inherit (cfglib) forAllSystems pkgsFor pathsIn;
      };

      configuration =
        {
          scopes = {inherit (cfglib.scopes) configuration common;};
          inherit (cfglib) mkModules;
        }
        // cfglib.scopes.common;
    };
  }
  // import ./hosts.nix {inherit cfglib inputs;}
  // import ./modules.nix {inherit cfglib inputs;}
  // import ./common.nix {inherit cfglib inputs;}
