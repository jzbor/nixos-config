{ config, pkgs, ... }:

{
  programs.adb.enable = true;
  users.users.jzbor.extraGroups = ["adbusers"];
}

