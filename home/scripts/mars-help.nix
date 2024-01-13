{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "mars-help";
  runtimeInputs = with pkgs; [ marswm ];
  text = builtins.readFile ./mars-help.sh;
}
