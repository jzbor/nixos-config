# Provide a fix for thinkpad touchpad that don't work after suspend

{ config, lib, pkgs, ... }:

{
  powerManagement.resumeCommands = ''
    modprobe -r psmouse && modprobe psmouse
  '';
}
