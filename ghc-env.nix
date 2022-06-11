{
    pkgs                    ? (import ./. {}).pkgs
,   haskellCompiler         ? "ghc923"
,   haskellHackageOverrides ? (self: original: {})  # Project-specific Hackage overrides
,   haskellLibraries        ? (hackagePackageSet: with hackagePackageSet; [ ])
,   localDevTools           ? (ps: with ps; [ gnumake
                                                  gitAndTools.pre-commit
                                                  lsof
                                                  which
                                                  libiconv  # required for building Cabal
                                                  cabal2nix ])


}:

let
    ghcVariant             = pkgs.haskell.packages;
    ghcPkgSetWithOverrides = ghcVariant.${haskellCompiler}.override {
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
    localTooling = [ ghc ] ++ (localDevTools pkgs);
}
