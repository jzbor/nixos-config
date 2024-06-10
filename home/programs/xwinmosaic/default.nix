{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.xwinmosaic;
in {
  options.jzbor-home.programs.xwinmosaic = {
    enable = mkEnableOption "Install xwinmosaic window viewer";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xwinmosaic
    ];

    xdg.configFile."xwinmosaic/config".source = ./config;
  };
}
