{   projectOverlays ? []
,   supportedGhcVersions ? [ "9122" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2025-06-15";
         url    = https://github.com/NixOS/nixpkgs/archive/41da1e3ea8e23e094e5e3eeb1e6b830468a7399e.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:0c30r57ycw3zvp99mq1cclnacxsqbj0667ww6nq14wf1zki077cf";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
