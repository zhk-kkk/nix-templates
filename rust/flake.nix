{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            openssl
            pkg-config
            rust-bin.stable.latest.default
            rust-analyzer
          ];

          shellHook = ''
            export PS1="\n\033[1;34m(devshell) \w$ \033[0m";
          '';
        };
      }
    );
}
