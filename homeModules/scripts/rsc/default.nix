{ pkgs, craneLib, lib,  ... }:

with lib;
let
  rsc = craneLib.buildPackage {
    name = "rust-script-collection";
    version = "0.1.0";

    src = ./.;
  };
  commands = [
    "create-workspace"
  ];
in pkgs.stdenvNoCC.mkDerivation {
  name = "rust-script-collection-wrapped";
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -vp $out/bin/
    ln -sv ${rsc}/bin/rsc $out/bin/rsc
  ''  + strings.concatMapStrings (x: "ln -sv ${rsc}/bin/rsc $out/bin/${x}; ") commands;
}

