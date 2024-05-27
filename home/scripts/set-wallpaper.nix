{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "set-wallpaper";
  runtimeInputs = with pkgs; [ xwallpaper ];
  text = builtins.readFile ./set-wallpaper.sh;
}
