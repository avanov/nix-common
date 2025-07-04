{   projectOverlays ? []
,   supportedGhcVersions ? [ "9102" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2025-06-15";
         url    = https://github.com/NixOS/nixpkgs/archive/6cae4972a7405bac89f5eb06b7658ef76bb626e6.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:0drc9jayrvlk4y9g5lddnk5wvihdv3rx4fknqf0dcki0vw6ndyks";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
