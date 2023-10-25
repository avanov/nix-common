{   projectOverlays ? []
,   supportedGhcVersions ? [ "963" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-10-23";
         url    = https://github.com/NixOS/nixpkgs/archive/12a0c89695463215427c5a9746600629fe1200f5.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:0bicpip6p97zfcbl4qmn0bhmcy6dsc85rkvagii4p9cshrrkkqrl";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
