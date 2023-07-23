{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-06-21";
         url    = https://github.com/NixOS/nixpkgs/archive/10db592f7d6af1985a5dccf337cfd7cc5ab3924e.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:193qbrcwqdmagny55vg97zswrklqnw10arq0fylp68s7dgiz6qqc";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
