{   haskellCompiler         # "ghcXXX" etc
,   isHaskellWithGMP        # true / false
,   pkgs                    # global nixpkgs set

    # Project-specific Hackage overrides, callCabal2Nix is provided as a means to build new packages and make them part
    # of the same Haskell package set as the original one
,   haskellHackageOverrides ? (self: original: {})
,   haskellLibraries        ? (hackagePackageSet: with hackagePackageSet; [ ])
,   localDevTools           ? (ps: with ps; [   gnumake
                                                pre-commit
                                                lsof
                                                which
                                                #libiconv  # required for building Cabal
                                                cabal2nix ])
}:

let
    ghcEdition       =  if   isHaskellWithGMP
                        then pkgs.haskell.packages
                        else pkgs.haskell.packages.native-bignum;

    haskellNamespace = ghcEdition.${haskellCompiler};
    hsLib            = pkgs.haskell.lib;

    innerOverrides = (self: original: 

        {
                # ghcide = self.callHackageDirect
                #     { pkg = "ghcide"; ver =  "2.7.0.0"; sha256 = "sha256-vqghYQAim0N0Ih7U6qdi6iAE7WeGMa07AlrZ9JUVwKM="; }
                #     {};

                # GHC 9.10: Remove in the next release
                # ghc-lib-parser = hsLib.overrideCabal original.ghc-lib-parser (old: rec {
                #                     version = "9.10.2.20250515";
                #                     sha256 = "sha256-azfFNPLyVoXe+PRdtesbK8/QEvcLEAkM07aZVEx9nPI=";
                #                     editedCabalFile = null;
                #                     });
                # stylish-haskell = hsLib.overrideCabal original.stylish-haskell (old: rec {
                #                     version = "0.15.0.1";
                #                     sha256 = "sha256-JS9/jqRSTOUl1RO00l5tMY0eEt3o+8hOLFVMdcJ5VQs=";
                #                     editedCabalFile = null;
                #                     });
                # ghcide = hsLib.doJailbreak (hsLib.overrideCabal original.ghcide (old: rec {
                #                     version = "2.11.0.0";
                #                     sha256 = "sha256-eotElZC4ykz6gMKKSqidmKdYZ+M7thscMR7x3g3cOTU=";
                #                     editedCabalFile = null;
                #                     }));
                # hls-test-utils = hsLib.doJailbreak original.hls-test-utils;
                # haskell-language-server = hsLib.doJailbreak original.haskell-language-server;

                # saves significant build time
                # scientific = hsLib.dontCheck original.scientific;
            });

    ghcPkgSetWithOverrides = haskellNamespace.override {
        overrides = pkgs.lib.composeExtensions innerOverrides haskellHackageOverrides;
    };

    # `ghc` is a derivation that contains GHC + required project libraries,
    # we can use it other shells and derivations as a single derivation
    # that represents our Haskell project with all its dependencies
    ghc = ghcPkgSetWithOverrides.ghcWithPackages haskellLibraries;

    # see : https://github.com/NixOS/nixpkgs/issues/208812
#    ghcjs = (pkgs.haskell.packages.ghcjs.override {
#        overrides = self: original: rec {
#            #exceptions = original.exceptions_0_10_7;
#            directory = original.directory_1_3_8_1;
#            directory_1_3_7_1 = null;
#        };
#    }).ghcWithPackages (ps: with ps; [ cabal-install ]);
    ghcjs = pkgs.haskell.compiler.ghcjs;

in

{
    inherit pkgs;
    inherit ghc;
    inherit ghcjs;
    inherit ghcPkgSetWithOverrides;
    inherit haskellNamespace;
    localTooling = [ ghc ] ++ (localDevTools pkgs);
}
