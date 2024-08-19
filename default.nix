{   projectOverlays ? []
,   supportedGhcVersions ? [ "966" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2024-08-19";
         url    = https://github.com/NixOS/nixpkgs/archive/e9b5094b8f6e06a46f9f53bb97a9573b7cedf2a2.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1wkdkga09d674srcf2ygybfqqcx5d4n5lw2qfpphpn8jffp4nah7";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
