# Bootstrap shell, that uses nixpkgs from the `flake.lock` file.
# Enter it either through `nix develop` or `nix-shell`.
let
  lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
in
  {
    pkgs ?
      (import (fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      })) {},
  }: {
    default = pkgs.mkShell {
      NIX_CONFIG = "experimental-features = nix-command flakes";
      nativeBuildInputs = with pkgs; [
        git
        nixd
        neovim
      ];
    };
  }
