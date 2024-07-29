{ pkgs, ... }:

{
  # Enable trim for ssds
  services.fstrim = {
    enable = true;
    interval = "daily";
  };
  # Workaround for also trimming /home drive
  systemd.services.fstrim.serviceConfig.ExecStart = "${pkgs.util-linux}/sbin/fstrim --verbose --all --quiet-unsupported";

  # Monitor hard drives
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.x11.enable = true;
    notifications.mail.enable = false;
  };

  # Automount encrypted drives on login
  security.pam.mount = {
    enable = true;
    extraVolumes = [
      "<volume user=\"jzbor\" fstype=\"crypt\" path=\"/dev/disk/by-label/crypt0-home\" mountpoint=\"~\" options=\"crypto_name=crypt0,allow_discard,fstype=ext4\"/>"
      "<volume user=\"jzbor\" fstype=\"crypt\" path=\"/dev/disk/by-label/crypt1-home\" mountpoint=\"~\" options=\"crypto_name=crypt1-home,allow_discard,fstype=ext4\"/>"
      # extra drive on desktop-i5
      "<volume user=\"jzbor\" fstype=\"crypt\" path=\"/dev/disk/by-uuid/2fb1ab80-c89e-419a-96f3-ec89edbd4f16\" mountpoint=\"~/.bigdata\" options=\"crypto_name=crypt1,allow_discard,fstype=ext4\"/>"
    ];
    createMountPoints = true;

    # Kill remaining processes after final logout
    #logoutTerm = true;
    #logoutWait = 0;  # seconds
  };
}

