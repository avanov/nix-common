let
    pkgs = (import ./. {}).pkgs;

in
    pkgs.mkShellNoCC {
        nativeBuildInputs = with pkgs; [ git gnumake ];
    }
