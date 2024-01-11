{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.jzbor-system.boot;
in {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = mkIf cfg.secureBoot {
    environment.systemPackages = with pkgs; [
      sbctl
    ];

    boot.bootspec.enable = true;
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
