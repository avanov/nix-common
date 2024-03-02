{   projectOverlays ? []
,   supportedGhcVersions ? [ "964" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-03-02";
         url    = https://github.com/NixOS/nixpkgs/archive/458b097d81f90275b3fdf03796f0563844926708.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:1vpbqcdn0a2j20l84bp0fsxk8fc13kf0b04yf7s47djvna545z4s";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
    inherit nixpkgs-src;
}
