{ lib, config, ... }:

with lib;
let
  cfg = config.jzbor-system.boot;
in {
  config = mkIf (cfg.scheme == "pinebook-pro") {
    # Boot loader
    boot.loader = {
      timeout = 5;
      efi.canTouchEfiVariables = false;
    };
    boot.loader.systemd-boot = {
      enable = true;
    };

    # Kernel version
    boot.kernelPackages = cfg.kernel;

    # Enable Firmware
    hardware.enableRedistributableFirmware = true;

    # Add adequate kernel modules
    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  };
}
