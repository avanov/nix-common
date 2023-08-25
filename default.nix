{   projectOverlays ? []
,   supportedGhcVersions ? [ "946" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-08-25";
         url    = https://github.com/NixOS/nixpkgs/archive/9201b5ff357e781bf014d0330d18555695df7ba8.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1cf2mnv9nmlycdgpsl1gc9rlvmzb4f4xk2k7q0fjq8mb9smskly7";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
