{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.fonts.fontconfig;
in mkIf cfg.enable {
  # TODO make sure installed fonts are the same as used in fonts.conf
  xdg.configFile."fontconfig/fonts.conf".source = ./fonts.conf;
}
