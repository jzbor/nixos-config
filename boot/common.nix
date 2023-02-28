{ lib, config, pkgs, ... }:

{
  # Boot loader
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
  boot.loader.systemd-boot {
    enable = true;
    memtest86.enable = true;
  };

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable Firmware
  hardware.enableRedistributableFirmware = true;
}
