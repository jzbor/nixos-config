# Provide a fix for thinkpad touchpad that don't work after suspend

{ config, lib, pkgs, ... }:

{
  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/modprobe -r psmouse && ${pkgs.kmod}/bin/modprobe psmouse
  '';
}
