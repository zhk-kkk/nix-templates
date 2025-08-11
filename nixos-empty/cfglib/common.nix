{
  cfglib,
  inputs,
  ...
}: let
  outputs = inputs.self.outputs;
  lib = inputs.nixpkgs.lib;
in {
  # Get all paths in a given directory root as a list
  pathsIn = dir:
    map (name: dir + "/${name}")
    (builtins.attrNames (builtins.readDir dir));

  # Get filename from a path without the extension
  baseNameStemOf = path: builtins.head (builtins.split "\\." (baseNameOf path));

  # Produce an attribute list for each system
  forAllSystems = lib.genAttrs [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  # Produce packages for a gives system
  pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};
}
