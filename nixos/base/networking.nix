{ lib, ... }:

with lib;
{
  # Networking
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.macAddress = "stable";

  # DNS Settings
  networking.nameservers = [ "5.75.234.6#dns.jzbor.de" "9.9.9.9#dns.quad9.net" ];
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  # Faster boot by avoiding to wait for network
  systemd.targets.network-online.wantedBy = mkForce []; # Normally ["multi-user.target"]
  systemd.targets.network.wantedBy = mkForce ["multi-user.target"];
}
