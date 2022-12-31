{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2022-12-31";
         url    = https://github.com/NixOS/nixpkgs/archive/f9a86d8f9b3861f1fcedc1eda3bce06472d7b8b7.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:179p3qh686g89c6bvl5xmjpvmysyxwqj7lfps7hfrvwpial18d30";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
