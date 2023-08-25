#
# Place global overrides and extra derivations here as described in https://nixos.wiki/wiki/Overlays#Examples_of_overlays
#
{
    supportedGhcVersions
}:

let

postgres-local-management-src = builtins.fetchTarball {
    name   = "postgres-local-management-src";
    url    = https://github.com/avanov/postgres-local-management/archive/2d3e363543644482f70f287a8606b8d73233cca7.tar.gz;
    sha256 = "sha256:13w9wvwk77qw8g4y5y1ips7yddji5abqqd9yrkypv8jpr19bldp1";
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
        builder = "${self.bash}/bin/bash";
        args    = [
            (self.writeScript "postgres-local-management-builder"
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
