{ lib, config, ... }:

with lib;
let
  cfg = config.jzbor-system.de.cinnamon;
in {
  options.jzbor-system.de.cinnamon = {
    enable = mkEnableOption "Enable Cinnamon desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;
  };
}
