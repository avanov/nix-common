{   projectOverlays ? []
,   supportedGhcVersions ? [ "948" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-11-21";
         url    = https://github.com/NixOS/nixpkgs/archive/fda1c759e01bcc9f94ecf237c85b70c2930dd58f.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:19pdmyqbsi4cyzjw02vzcwp3dm8x67abbl63mrwdy4j5hhcbvp1b";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
