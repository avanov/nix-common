{   projectOverlays ? []
,   supportedGhcVersions ? [ "966" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2024-09-01";
         url    = https://github.com/NixOS/nixpkgs/archive/85f7e662eda4fa3a995556527c87b2524b691933.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1p8qam6pixcin63wai3y55bcyfi1i8525s1hh17177cqchh1j117";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
