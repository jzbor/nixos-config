{ pkgs, lib, config, ... }:

{
  system.stateVersion = "22.11";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = false;
  };

  jzbor-system.features.gaming.enable = true;

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
