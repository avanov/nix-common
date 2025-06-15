{   haskellVersion
}:

let

pkgs    = (import ./. { supportedGhcVersions = ["${haskellVersion}"]; }).pkgs;
ghcEnv  = (import ./ghc-env.nix
    {   pkgs = pkgs;
        haskellCompiler = "ghc${haskellVersion}";
        isHaskellWithGMP = false;
        haskellHackageOverrides = (self: original: {});
        haskellLibraries = hackagePkgs: with hackagePkgs; [
            # if hls is built from toplevel pkgs, it has to match the version of the project's GHC, otherwise VSCode plugin would complain
            # on version mismatch.
            haskell-language-server
        ];
    });


testShell = pkgs.mkShellNoCC {
    # Sets the build inputs, i.e. what will be available in our
    # local environment.
    nativeBuildInputs
        = with pkgs; [ ghcEnv.ghcjs ]
        ++ ghcEnv.localTooling;
};


pythonTestShell = pkgs.mkShell
    {   buildInputs = with pkgs; [ python313 ];
    };

in

{
    inherit testShell;
    inherit pythonTestShell;
}
