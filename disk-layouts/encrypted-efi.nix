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
            testboot = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            testroot = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt2";
                settings.allowDiscards = true;
                extraFormatArgs = [ "--type" "luks2" "--pbkdf" "argon2id" ];
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}

