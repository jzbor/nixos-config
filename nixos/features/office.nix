{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.office;
in {
  options.jzbor-system.features.office = {
    enable = mkOption {
      type = bool;
      description = "Enable office feature";
      default = config.jzbor-system.features.enableDesktopDefaults;
    };

    printing = {
      enable = mkOption {
        type = bool;
        description = "Enable printer support";
        default = true;
      };

      networking = mkOption {
        type = bool;
        description = "Enable network printer support";
        default = true;
      };

      drivers = mkOption {
        type = listOf package;
        description = "List of drivers to include";
        default = [];
      };

      vendors = {
        hp = mkOption {
          type = bool;
          description = "Enable HP printing drivers";
          default = false;
        };

        samsung = mkOption {
          type = bool;
          description = "Enable Samsung printing drivers";
          default = false;
        };
      };
    };

    scanning = {
      enable = mkOption {
        type = bool;
        description = "Enable scanner support";
        default = true;
      };

      extraBackends = mkOption {
        type = listOf package;
        description = "SANE backends";
        default = [];
      };
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      libreoffice-fresh
    ] ++ (if cfg.scanning.enable then [ pkgs.simple-scan ] else []);


    # Printing and Scanning
    services.printing = {
      inherit (cfg.printing) enable;
      drivers = (if cfg.printing.vendors.hp then (with pkgs; [ hplipWithPlugin ]) else [])
                    ++ (if cfg.printing.vendors.samsung then (with pkgs; [ samsung-unified-linux-driver ]) else []);
    };

    programs.system-config-printer.enable = cfg.printing.enable;

    services.udev.packages = mkIf cfg.printing.vendors.hp (with pkgs;[
      hplipWithPlugin
    ]);

    hardware.sane = {
      inherit (cfg.scanning) enable;
      inherit (cfg.scanning) extraBackends;
    };
  };
}
