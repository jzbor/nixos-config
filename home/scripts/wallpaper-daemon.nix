{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "wallpaper-daemon";
  runtimeInputs = with pkgs; [ gnugrep xorg.xev xwallpaper ];
  text = builtins.readFile ./wallpaper-daemon.sh;
}
