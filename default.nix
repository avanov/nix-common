{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-06-21";
         url    = https://github.com/NixOS/nixpkgs/archive/3556804b333d0a810e0c99a853bf49dc02c46c5a.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1j16ybclfswjavd5pns4wgq7ijlcfrxkl2fbkvcd0za4s9pla9wg";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
