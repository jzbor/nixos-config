{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "screencast";
  runtimeInputs = with pkgs; [ ffmpeg-full slop xorg.xrandr ];
  text = builtins.readFile ./screencast.sh;
}
