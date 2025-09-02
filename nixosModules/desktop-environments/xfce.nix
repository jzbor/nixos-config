{ lib, config, ... }:

with lib;
let
  cfg = config.jzbor-system.de.xfce;
in {
  options.jzbor-system.de.xfce = {
    enable = mkEnableOption "Enable XFCE desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.xfce.enable = true;
  };
}
