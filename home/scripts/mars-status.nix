{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "mars-status";
  runtimeInputs = with pkgs; [
    gnugrep
    libcanberra-gtk3
    libnotify
    power-profiles-daemon
    pulseaudio
    xkb-switch
    xmenu
  ];
  text = builtins.readFile ./mars-status.sh;
}
