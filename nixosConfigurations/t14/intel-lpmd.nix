{ inputs, ... }: {
  environment.systemPackages = [
    inputs.parcels.packages.x86_64-linux.intel-lpmd
  ];

  services.upower.enable = true;

  systemd.services.intel_lpmd = {
    wantedBy = [ "multi-user.target" ];
    description = "Intel Linux Energy Optimizer (lpmd) Service";
    documentation = [ "man:intel_lpmd(8)" ];
    startLimitIntervalSec = 200;
    startLimitBurst = 5;
    aliases = [ "org.freedesktop.intel_lpmd.service" ];

    # serviceConfig = {
    #   Type = "dbus";
    #   SuccessExitStatus = 2;
    #   BusName = "org.freedesktop.intel_lpmd";
    #   ExecStart = "${inputs.parcels.packages.x86_64-linux.intel-lpmd}/bin/intel_lpmd --loglevel=info --systemd --dbus-enable";
    #   Restart = "on-failure";
    #   RestartSec = 30;
    #   PrivateTmp = "yes";
    # };
    serviceConfig = {
      Type = "simple";
      SuccessExitStatus = 2;
      ExecStart = "${inputs.parcels.packages.x86_64-linux.intel-lpmd}/bin/intel_lpmd --loglevel=info --systemd";
      Restart = "on-failure";
      RestartSec = 30;
      PrivateTmp = "yes";
    };
  };

  environment.etc."intel_lpmd/intel_lpmd_config_F6_M189_T17.xml".source = ./intel_lpmd_config.xml;
}
