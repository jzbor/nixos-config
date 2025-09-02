{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.vis;
in {
  options.jzbor-home.programs.vis = {
    enable = mkEnableOption "Install xwinmosaic window viewer";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fzf
      vis
    ];

    xdg.configFile."vis/visrc.lua".source = ./files/visrc.lua;
  };
}
