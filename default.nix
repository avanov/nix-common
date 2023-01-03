{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-01-03";
         url    = https://github.com/NixOS/nixpkgs/archive/39bc9634f64232e817ddc910f5b683c146f2b454.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1920zaji756mkq8mwgfjgl3nvsc4x8b10l6xl9vx2qannsy1jbml";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
