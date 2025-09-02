{ pkgs, lib, inputs, ... }:

pkgs.symlinkJoin {
  name = "homeScripts";
  paths = lib.attrsets.attrValues (import ./packages.nix { inherit pkgs inputs; });
}
