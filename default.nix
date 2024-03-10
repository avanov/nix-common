{   projectOverlays ? []
,   supportedGhcVersions ? [ "964" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-03-10";
         url    = https://github.com/NixOS/nixpkgs/archive/db339f1706f555794b71aa4eb26a5a240fb6a599.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:0fph9npjb4gm391qwfp7i8yrvnbzl3slv50smjxhasyx29mf9vkc";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
