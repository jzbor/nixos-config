{ pkgs, lib, config, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.boot;
in {
  imports = [
    ./schemes
    ./secure-boot.nix
    ./disks.nix
  ];

  options.jzbor-system.boot = {
    scheme = mkOption {
      type = enum [ "traditional" "pinebook-pro" ];
      description = "Boot scheme to be used";
    };

    kernel = mkOption {
      type = attrs;
      description = "Kernel package to be used";
      default = pkgs.linuxPackages_latest;
    };

    secureBoot = mkEnableOption "Enable secure boot";
  };
}
