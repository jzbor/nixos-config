{ lib, config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Splash screen
  boot.plymouth = {
    enable = true;
    #theme = "lone";
    #themePackages = with pkgs; [
    #  adi1090x-plymouth
    #];
  };

  # boot.initrd.systemd.enable = true;

  # Disable unnecessary output
  boot.kernelParams = [
    "quiet"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
}
