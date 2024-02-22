{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "mars-startup";
  runtimeInputs = with pkgs; [ marswm touchegg xorg.xmodmap ];
  text = builtins.readFile ./mars-startup.sh;
}
