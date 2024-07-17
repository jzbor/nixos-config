{ config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.audio;
in {
  options.jzbor-system.features.audio = {
    enable = mkOption {
      type = bool;
      description = "Enable sound system";
      default = config.jzbor-system.features.enableBaseFeatures;
    };
  };

  config = mkIf cfg.enable {
    # Pipewire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
  };
}
