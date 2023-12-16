{   projectOverlays ? []
,   supportedGhcVersions ? [ "963" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-12-16";
         url    = https://github.com/NixOS/nixpkgs/archive/7ee71fe7169527f41a9567de93ea4315d570a5ab.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1m8hdqllwndyvv9l3x6rvc3ss6di27skmas5j3czm138h5lx6zk0";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
