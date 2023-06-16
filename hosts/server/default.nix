{ config, lib, ... }:

{
  imports = [
    # Include common configuration files
    ../common
  ];

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0"; # either ens3 (amd64) or enp1s0 (arm64)
    networkConfig.DHCP = "ipv4";

    routes = [
      { routeConfig.Gateway = "fe80::1"; }
    ];
  };
}
