{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2022-12-07";
         url    = https://github.com/NixOS/nixpkgs/archive/31602ee309fd8ce6dd5af3a1effae272238d5337.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "19drzzq76169iv15mjys89136s347h5jcp8ihy66r14ami9a1yib";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
