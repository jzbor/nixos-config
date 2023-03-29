{ config, pkgs, ... }:

{
  # Enable Avahi for discovery of network printers
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns = true;
  };

  # CUPS
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplipWithPlugin
      samsung-unified-linux-driver
      splix
    ];
  };

  # hplip-plugin also requires some udev rules to be installed
  services.udev.packages = [
    pkgs.hplipWithPlugin
  ];
}
