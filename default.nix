{}:

let
    pkgs = import (builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot";
         # Commit hash for nixos-unstable as of 2021-04-29
         url    = https://github.com/NixOS/nixpkgs/archive/79225c623d2f07f095251d3e509cc6a4cee6119e.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "02j88v5yyvh1ximdi4wn46mb5vfrl0rdmbmv2mi644gh4wzfn4x3";
    }) {};

in

{
    inherit pkgs;
}
