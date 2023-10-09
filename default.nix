{   projectOverlays ? []
,   supportedGhcVersions ? [ "963" ]
}:

let
    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot-2023-10-09";
         url    = https://github.com/NixOS/nixpkgs/archive/2646b294a146df2781b1ca49092450e8a32814e1.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "sha256:185xvyyxs6m6n3pldyc8ymsr7yhxhf72rlgcm1v5qb41s0n2vy3i";
    };

    commonOverlays = (import ./overlays.nix { inherit supportedGhcVersions; }).overlays;

in

{
    pkgs = import nixpkgs-src { overlays = [ commonOverlays ] ++ projectOverlays; };
}
