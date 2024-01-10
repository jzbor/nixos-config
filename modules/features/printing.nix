{ config, pkgs, ... }:

{
  # Enable Avahi for discovery of network printers
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
  };

  # CUPS
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      # gutenprint  # seems to be broken
      # gutenprintBin
      hplipWithPlugin
      samsung-unified-linux-driver
      splix
    ];
  };

  # hplip-plugin also requires some udev rules to be installed
  services.udev.packages = [
    pkgs.hplipWithPlugin
  ];

  # Scanning with SANE (e.g. for GNOME Simple Scanner)
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin  # HP
      #sane-airscan     # Apple and Microsoft
    ];
  };
  #services.ipp-usb.enable = true; # USB scanners
}
