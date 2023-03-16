{ lib, config, pkgs, ... }:

{
  # Boot loader
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
  };

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable Firmware
  hardware.enableRedistributableFirmware = true;

  # Faster boot by avoiding to wait for network
  systemd.targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
}
