{ flake, inputs, perSystem, ... }:

let
  pkgs = perSystem.nixpkgs;
  inherit (pkgs) lib;
in {
  imports = [
    flake.nixosModules.default
    inputs.nixos-hardware.nixosModules.pine64-pinebook-pro
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "22.11";
  networking.hostName = "pinebook-pro";

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
