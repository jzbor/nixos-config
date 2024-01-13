{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    buttermilk
  ];
  xdg.configFile."buttermilk/buttermilk.conf".source = ./buttermilk.conf;
}
