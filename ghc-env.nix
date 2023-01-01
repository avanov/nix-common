{   haskellCompiler         # "ghc944" etc
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

    haskellNamespace       = ghcEdition.${haskellCompiler};

    ghcPkgSetWithOverrides = haskellNamespace.override {
        overrides = self: original: {
            # not yet
        } // haskellHackageOverrides self original;  # apply (union) project-specific Hackage overrides after global overrides
    };

    # `ghc` is a derivation that contains GHC + required project libraries,
    # we can use it other shells and derivations as a single derivation
    # that represents our Haskell project with all its dependencies
    ghc = ghcPkgSetWithOverrides.ghcWithPackages haskellLibraries;

in

{
    inherit pkgs;
    inherit ghc;
    inherit haskellNamespace;
    localTooling = [ ghc ] ++ (localDevTools pkgs);
}
