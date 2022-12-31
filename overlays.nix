#
# Place global overrides and extra derivations here as described in https://nixos.wiki/wiki/Overlays#Examples_of_overlays
#
{
    supportedGhcVersions ? [ "944" ]
}:

let

postgres-local-management-src = builtins.fetchTarball {
    name   = "postgres-local-management-src";
    url    = https://github.com/avanov/postgres-local-management/archive/f8d96a5751176990512a602d1f9bffdc9ee0334a.tar.gz;
    sha256 = "sha256:105kzq3dprzdmbi0d3nr3p3wx45vv4k3smf2y17bh01nwy65a3ld";
};

overlays = (self: original: rec {

    # Upstream ghcid doesn't expose ghc(i) as a propagated dependency, so we fix it on our side
    ghcid = original.ghcid.overrideAttrs (oldAttrs: {
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ original.ghc ];
    });

    haskell-language-server = original.haskell-language-server.override {
        supportedGhcVersions = supportedGhcVersions;
    };

    postgres-local-management = self.stdenv.mkDerivation {
        name    = "postgres-local-management";
        src     = postgres-local-management-src;
        wget    = self.wget;
        builder = "${self.bash}/bin/bash";
        args    = [
            (self.writeScript "wait-for-builder"
                ''
                    source $stdenv/setup
                    install -d $out/
                    cp $src/Makefile $out/Makefile
                ''
            )];
        };
});

in

{
    inherit overlays;
}
