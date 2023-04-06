{ lib, config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Xfce
  services.xserver.desktopManager.xfce.enable = true;
}
