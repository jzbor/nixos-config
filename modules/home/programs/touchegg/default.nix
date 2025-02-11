{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.touchegg;
in {
  options.jzbor-home.programs.touchegg = {
    enable = mkEnableOption "Install touchegg";
  };

  config = mkIf cfg.enable{
    home.packages = with pkgs; [ touchegg xdotool ];
    xdg.configFile."touchegg/touchegg.conf".source = ./touchegg.xml;
  };
}
