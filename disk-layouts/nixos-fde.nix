{ disk, ... }:
{
  disko.devices = {
    disk = {
      vdb = {
        device = "${disk}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # has to be uppercase to be first
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = [ "-n" "nixos-boot" ];  # no more than 11 characters
              };
            };
            root = {
              size = "256G";
              content = {
                type = "luks";
                name = "crypt0";
                settings.allowDiscards = true;
                extraFormatArgs = [ "--type" "luks2" "--pbkdf" "argon2id" "--label" "crypt0-root" ];
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  extraArgs = [ "-L" "nixos-root" ];
                };
              };
            };
            home = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt1";
                settings.allowDiscards = true;
                extraFormatArgs = [ "--type" "luks2" "--pbkdf" "argon2id" "--label" "crypt1-home" ];
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/home/jzbor";
                  extraArgs = [ "-L" "nixos-home" ];
                };
              };
            };
          };
        };
      };
    };
  };
}

