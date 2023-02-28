{ lib, config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Splash screen
  boot.plymouth = {
    enable = true;
    theme = "lone";
    themePackages = with pkgs; [
      adi1090x-plymouth
    ];
  };

  boot.initrd.systemd.enable = true;

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];
}
