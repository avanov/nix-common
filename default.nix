{   projectOverlays ? []
,   supportedGhcVersions ? [ "966" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2024-09-01";
         url    = https://github.com/NixOS/nixpkgs/archive/b833ff01a0d694b910daca6e2ff4a3f26dee478c.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1v3y9km48glcmgzk7h8s9sg5sgv1w86pyad973d981sk84a85cdl";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
