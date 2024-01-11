{ pkgs, lib, config, ... }:

{
  system.stateVersion = "22.11";

  jzbor-system.boot = {
    scheme = "pinebook-pro";
  };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8*1024;  # in megabytes
  }];

  services.logind.powerKey = "ignore";
  environment.variables."PAN_MESA_DEBUG" = "gl3";
  services.smartd.enable = lib.mkForce false;
}
