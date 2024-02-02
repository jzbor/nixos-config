{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.xmenu;
in {
  options.jzbor-home.programs.xmenu = {
    enable = mkEnableOption "Install xmenu";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ xmenu ];

    xresources.properties = {
      "xmenu.foreground" = "#${config.colorScheme.palette.base0F}";
      "xmenu.background" = "#${config.colorScheme.palette.base00}";
      "xmenu.selforeground" = "#${config.colorScheme.palette.base00}";
      "xmenu.selbackground" = "#${config.colorScheme.palette.base0F}";

      "xmenu.border" = "#${config.colorScheme.palette.base02}";
      "xmenu.separator" = "#${config.colorScheme.palette.base02}";
      "xmenu.borderWidth" = 1;
      "xmenu.separatorWidth" = 4;
    };
  };
}
