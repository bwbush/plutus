{
}:

let

  drv = import ./default.nix {};
  pkgs = drv.pkgs;
  ghc = drv.haskell.packages.ghcWithPackages (ps: with ps; [
    marlowe-playground-server
    plutus-playground-server
  ]);

in

  pkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = [
      ghc
    ];
  }
