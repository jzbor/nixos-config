{ pkgs, lib, ... }@attrs:

pkgs.symlinkJoin {
  name = "homeScripts";
  paths = lib.attrsets.attrValues (import ./packages.nix attrs);
}
