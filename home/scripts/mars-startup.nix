{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "mars-startup";
  runtimeInputs = with pkgs; [ marswm touchegg ];
  text = builtins.readFile ./mars-startup.sh;
}
