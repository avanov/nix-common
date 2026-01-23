{   projectOverlays ? []
,   supportedGhcVersions ? [ "9122" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2026-01-23";
         url    = https://github.com/NixOS/nixpkgs/archive/ed142ab1b3a092c4d149245d0c4126a5d7ea00b0.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1h7v295lpjfxpxkag2csam7whx918sdypixdi8i85vlb707gg0vm";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
