{ craneLib, ... }:

craneLib.buildPackage {
  pname = "rust-script-collection";
  version = "0.1.0";

  src = ./.;
}

