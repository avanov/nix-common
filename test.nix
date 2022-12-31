{   haskellCompiler
}:

let

pkgs    = (import ./. {}).pkgs;
ghcEnv  = (import ./ghc-env.nix { pkgs = pkgs; haskellCompiler = haskellCompiler; isHaskellWithGMP = false; });


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
