{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "spotify-wm-compat";
  runtimeInputs = with pkgs; [ marswm xdotool ];
  text = builtins.readFile ./spotify-wm-compat.sh;
}
