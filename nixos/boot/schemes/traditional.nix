{ lib, config, ... }:

with lib;
let
  cfg = config.jzbor-system.boot;
in {
  config = mkIf (cfg.scheme == "traditional") {
    boot = {
      # Boot loader
      loader = {
        timeout = 5;
        efi.canTouchEfiVariables = true;

        systemd-boot = {
          enable = true;
          memtest86.enable = false;
        };
      };

      # Kernel version
      kernelPackages = cfg.kernel;

      # Add adequate kernel modules
      initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      initrd.systemd.enable = true;
    };

    # Enable Firmware
    hardware.enableRedistributableFirmware = true;
  };
}
