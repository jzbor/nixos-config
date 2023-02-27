
{ lib, config, pkgs, ... }:

{
  boot.plymouth.enable = true;

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

}
