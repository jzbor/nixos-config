{ pkgs, config, ... }:

{
  xresources.properties = {
    "*foreground" = "#${config.colorScheme.colors.base0F}";
    "*background" = "#${config.colorScheme.colors.base00}";
  };
}

