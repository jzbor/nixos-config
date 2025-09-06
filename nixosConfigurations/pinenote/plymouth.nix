{ inputs, ... }: {
  boot = {
    plymouth = {
      enable = true;
      extraConfig = ''
        ShowDelay=0
        DeviceScale=2
      '';
      theme = "nix-eink";
      themePackages = [
        inputs.nixos-pinenote.packages.aarch64-linux.plymouth-nix-eink
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "plymouth.debug"
    ];
  };
}
