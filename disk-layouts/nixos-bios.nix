{ disk, ... }:
{
  disko.devices = {
    disk = {
      vdb = {
        device = "${disk}";
        type = "disk";
        content = {
          type = "table";
          format = "msdos";
          partitions = {
            BOOT = {
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
              size = "128G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-L" "nixos-root" ];
              };
            };
            home = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt2";
                settings.allowDiscards = true;
                extraFormatArgs = [ "--type" "luks2" "--pbkdf" "argon2id" "--label" "crypt0-home" ];
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
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

