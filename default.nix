{   projectOverlays ? []
,   supportedGhcVersions ? [ "946" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-08-26";
         url    = https://github.com/NixOS/nixpkgs/archive/1e44a037bbf4fcaba041436e65e87be88f3f495b.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1fgdz3x9s3klihwiq49gyr26ilsps6r2jwqy666w4ypzvgkh8hgl";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
