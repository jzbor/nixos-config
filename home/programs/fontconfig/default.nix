{ pkgs, ... }:

{
  # TODO make sure installed fonts are the same as used in fonts.conf
  xdg.configFile."fontconfig/fonts.conf".source = ./fonts.conf;
}
