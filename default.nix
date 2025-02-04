{   projectOverlays ? []
,   supportedGhcVersions ? [ "9101" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2025-02-04";
         url    = https://github.com/NixOS/nixpkgs/archive/95ea544c84ebed84a31896b0ecea2570e5e0e236.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:12xazxkw5fff9dwq0q530wx5j2wk2r5apis7j2j396c6wf6cjaqg";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
