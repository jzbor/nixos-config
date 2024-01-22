{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "replay-area";
  runtimeInputs = with pkgs; [ ffmpeg-full slop ];
  text = builtins.readFile ./replay-area.sh;
}
