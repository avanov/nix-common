{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot";
         # Commit hash for nixos-unstable as of 2022-09-15
         url    = https://github.com/NixOS/nixpkgs/archive/1637945189070199494480264357738cc946c70c.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "0n9cajpbhsga77ssq8axvy7b28x4p7phkx4nb1216b07ar87qzim";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
