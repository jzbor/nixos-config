{ config, ... }:

{
  xresources.properties = {
    "*foreground" = "#${config.colorScheme.palette.base0F}";
    "*background" = "#${config.colorScheme.palette.base00}";
  };
}

