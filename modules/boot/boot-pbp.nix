
{ lib, config, pkgs, ... }:

{
  # Boot loader
  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = false;
    efi.efiSysMountPoint = "/boot/efi";
  };
  boot.loader.systemd-boot = {
    enable = true;
  };

  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable Firmware
  hardware.enableRedistributableFirmware = true;

  # Add adequate kernel modules
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];

  # Faster boot by avoiding to wait for network
  systemd.targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
}
