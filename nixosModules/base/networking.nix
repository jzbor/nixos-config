{ pkgs, lib, ... }:

with lib;
{
  # Networking
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "stable";
    plugins = lib.mkForce (with pkgs; [
      networkmanager-openvpn
    ]);
  };

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

  # TODO: Remove once https://nixpkgs-tracker.jzbor.de/?pr=440130 is fixed
  systemd.services."hotfix-resolved" = {
    script = ''
      set -eu
      ${pkgs.systemd}/bin/systemctl restart systemd-resolved
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    startAt = "*:0/30";
  };

  # systemd.timers."hotfix-resolved" = {
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnBootSec = "5m";
  #     OnUnitActiveSec = "5m";
  #     Unit = "hotfix-resolved.service";
  #   };
  # };

  # systemd.services."hotfix-resolved" = {
  #   script = ''
  #     set -eu
  #     ${pkgs.systemd}/bin/systemctl restart systemd-resolved
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "root";
  #   };
  # };
}
