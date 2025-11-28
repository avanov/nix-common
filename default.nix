{   projectOverlays ? []
,   supportedGhcVersions ? [ "9122" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2025-11-28";
         url    = https://github.com/NixOS/nixpkgs/archive/0d59e0290eefe0f12512043842d7096c4070f30e.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:04a03ffnjc2y22460n01djgvqgkrnmm02kqhrlzpd3wwjjbz3bb7";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
