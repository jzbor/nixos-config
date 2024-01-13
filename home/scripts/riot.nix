{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "riot";
  runtimeInputs = with pkgs; [
    bc
    marswm
    slop
    xdo
    xmenu
    xorg.xwininfo
  ];
  text = builtins.readFile ./riot.sh;
}
