{ pkgs, ... }:

{
  home.packages = with pkgs; [ touchegg xdotool ];

  xdg.configFile."touchegg/touchegg.conf".source = ./touchegg.xml;
}
