{ lib, config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Splash screen
  boot.plymouth.enable = false;
}
