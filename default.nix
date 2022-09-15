{   projectOverlays ? []
}:

let
    overlay = (self: original: rec {
        # Place overrides here as described in https://nixos.wiki/wiki/Overlays#Examples_of_overlays

        # Upstream ghcid doesn't expose ghc(i) as a propagated dependency, so we fix it on our side
        ghcid = original.ghcid.overrideAttrs (oldAttrs: {
            propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ original.ghc ];
        });
    });

    nixpkgs-src = builtins.fetchTarball {
         # Descriptive name to make the store path easier to identify
         name   = "nix-common-snapshot";
         # Commit hash for nixos-unstable as of 2022-09-15
         url    = https://github.com/NixOS/nixpkgs/archive/1637945189070199494480264357738cc946c70c.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "0n9cajpbhsga77ssq8axvy7b28x4p7phkx4nb1216b07ar87qzim";
    };

in

{
    pkgs = import nixpkgs-src { overlays = [ overlay ] ++ projectOverlays; };
}
