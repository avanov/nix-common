{   projectOverlays ? []
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-03-03";
         url    = https://github.com/NixOS/nixpkgs/archive/9092f0d9ba428a28974726eceb8dcb25ba213de1.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1hrq71ss5j7hvjj3pmpbbxdh8kg993dqwdd41cjwq8sp1f9876r6";
    };

    commonOverlays = (import ./overlays.nix {}).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
