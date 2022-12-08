let

ghcEnv  = (import ./ghc-env.nix {});
pkgs    = ghcEnv.pkgs;


testShell = pkgs.mkShellNoCC {
    # Sets the build inputs, i.e. what will be available in our
    # local environment.
    nativeBuildInputs
        = with pkgs; [  haskell-language-server ]
        ++ ghcEnv.localTooling;
};

in



{
    inherit testShell;
}