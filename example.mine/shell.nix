{
  system ? builtins.currentSystem
, crossSystem ? null
, config ? { allowUnfreePredicate = (import ../lib.nix).unfreePredicate; }
, sourcesOverride ? { }
, packages ? import ../nix { inherit system crossSystem config sourcesOverride rev checkMaterialization; }
, pkgs ? packages.pkgs
, pkgsLocal ? packages.pkgsLocal
, pkgsMusl ? packages.pkgsMusl
, rev ? null
, checkMaterialization ? false
}:

let

  inherit (pkgsLocal) haskell;

  ghc = haskell.packages.ghcWithPackages (ps: with ps; [
    marlowe-playground-server
    plutus-playground-server
  ]);

in

  pkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = [
      pkgs.cabal-install
      ghc
    ];
  }
