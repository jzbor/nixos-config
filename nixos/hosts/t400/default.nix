{ lib, ... }:

with lib;
{
  system.stateVersion = "23.11";

  jzbor-system.boot = {
    scheme = "bios";
  };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8*1024;  # in megabytes
  }];

  fileSystems."/" = mkForce {
    device = "/dev/disk/by-label/nixos-root";
    fsType = "ext4";
  };
  fileSystems."/boot" = mkForce{
    device = "/dev/disk/by-label/nixos-boot";
    fsType = "vfat";
  };

}
