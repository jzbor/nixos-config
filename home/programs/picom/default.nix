{ lib, config, ... }:

with lib;
let
  cfg = config.services.picom;
in mkIf cfg.enable {
  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
