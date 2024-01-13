
{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [ xmenu ];

  xresources.properties = {
    "xmenu.foreground" = "#${config.colorScheme.colors.base0F}";
    "xmenu.background" = "#${config.colorScheme.colors.base00}";
    "xmenu.selforeground" = "#${config.colorScheme.colors.base00}";
    "xmenu.selbackground" = "#${config.colorScheme.colors.base0F}";

    "xmenu.border" = "#${config.colorScheme.colors.base02}";
    "xmenu.separator" = "#${config.colorScheme.colors.base02}";
    "xmenu.borderWidth" = 1;
    "xmenu.separatorWidth" = 4;
  };
}
