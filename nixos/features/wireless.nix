{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.wireless;
in {
  options.jzbor-system.features.wireless = {
    enable = mkOption {
      type = bool;
      description = "Enable wireless protocols";
      default = config.jzbor-system.features.enableBaseFeatures;
    };

    bluetooth = mkOption {
      type = bool;
      description = "Enable bluetooth protocol";
      default = true;
    };
  };

  config = {
    # Bluetooth
    hardware.bluetooth.enable = cfg.enable && cfg.bluetooth;
    services.blueman.enable = cfg.enable && cfg.bluetooth;
  };
}
