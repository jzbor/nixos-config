{ lib, config, ... }:

with lib;
let
  cfg = config.jzbor-system.boot;
in {
  config = mkIf (cfg.scheme == "bios") {
    # Boot loader
    boot.loader = {
      timeout = 5;
      efi.canTouchEfiVariables = true;
      grub.enable = true;
      grub.device = "/dev/disk/by-label/nixos-boot";
      grub.efiSupport = true;
    };

    # Kernel version
    boot.kernelPackages = cfg.kernel;

    # Enable Firmware
    hardware.enableRedistributableFirmware = true;

    # Add adequate kernel modules
    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    boot.initrd.systemd.enable = true;
  };
}
