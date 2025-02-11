{ pkgs, lib, ... }:

with lib;
with types;
{
  imports = [
    ./schemes
    ./secure-boot.nix
    ./disks.nix
  ];

  options.jzbor-system.boot = {
    scheme = mkOption {
      type = enum [ "bios" "traditional" "pinebook-pro" ];
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
