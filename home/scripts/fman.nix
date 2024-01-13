{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "fman";
  runtimeInputs = with pkgs; [ fzf man ];
  text = builtins.readFile ./fman.sh;
}
