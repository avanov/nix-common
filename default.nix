{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2022-12-31";
         url    = https://github.com/NixOS/nixpkgs/archive/804e7ddc2c06aaf12cbc158f5039fbce4ae95507.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:02ayxnr38xi8gc15vgjvyq01nlpbqfbzfsg868yqc6m5affv9dll";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
