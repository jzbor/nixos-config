{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "nix-maintenance";
  runtimeInputs = with pkgs; [];
  text = builtins.readFile ./nix-maintenance.sh;
}
