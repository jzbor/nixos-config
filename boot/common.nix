{ lib, config, pkgs, ... }:

{
  # Boot loader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
