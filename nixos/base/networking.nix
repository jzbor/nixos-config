{ lib, ... }:

{
  # Networking
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.macAddress = "stable";

  # DNS Settings
  networking.nameservers = [ "5.75.234.6#dns.jzbor.de" "9.9.9.9#dns.quad9.net" ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}
