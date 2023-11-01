{   projectOverlays ? []
,   supportedGhcVersions ? [ "947" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-11-01";
         url    = https://github.com/NixOS/nixpkgs/archive/5363991a6fbb672549b6c379cdc1e423e5bf2d06.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1zkz59581qxfw9sdjh3mgyw02mpax9p353g6rzdbg69gzij8kij8";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
