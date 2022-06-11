{}:

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
         # Commit hash for nixos-unstable as of 2022-06-11
         url    = https://github.com/NixOS/nixpkgs/archive/6478045724f2413bf200b8efc687ebe0058ab39e.tar.gz;
         # Hash obtained using `nix-prefetch-url --unpack <url>`
         sha256 = "1mlgd9mj1sik1lxr9sbkbi1wmjnfward8zsh5nr7zkwi0kdy0ky8";
    };

in

{
    pkgs = import nixpkgs-src { overlays = [ overlay ]; };
}
