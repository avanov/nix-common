{   haskellCompiler         # "ghc962" etc
,   isHaskellWithGMP        # true / false
,   pkgs                    # global nixpkgs set

,   haskellHackageOverrides ? (self: original: {})  # Project-specific Hackage overrides
,   haskellLibraries        ? (hackagePackageSet: with hackagePackageSet; [ ])
,   localDevTools           ? (ps: with ps; [   gnumake
                                                gitAndTools.pre-commit
                                                lsof
                                                which
                                                libiconv  # required for building Cabal
                                                cabal2nix ])
}:

let
    ghcEdition       =  if   isHaskellWithGMP
                        then pkgs.haskell.packages
                        else pkgs.haskell.packages.native-bignum;

    haskellNamespace = ghcEdition.${haskellCompiler};

    ghcPkgSetWithOverrides = haskellNamespace.override {
        overrides = haskellHackageOverrides;
    };

    # `ghc` is a derivation that contains GHC + required project libraries,
    # we can use it other shells and derivations as a single derivation
    # that represents our Haskell project with all its dependencies
    ghc = ghcPkgSetWithOverrides.ghcWithPackages haskellLibraries;

    hsLib = pkgs.haskell.lib;
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
