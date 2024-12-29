{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.ghostty;
in {
  options.jzbor-home.programs.ghostty = {
    enable = mkEnableOption "Install ghostty terminal";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ghostty
    ];

    xdg.configFile."ghostty/config".text = builtins.concatStringsSep "\n" [
      (builtins.readFile ./ghostty.conf)
      ''
        # foreground and background
        foreground = ebdbb2
        background = 262626

        # color palette
        palette = 0=282828
        palette = 1=cc231c
        palette = 2=97971a
        palette = 3=d69921
        palette = 4=448587
        palette = 5=b16285
        palette = 6=679c69
        palette = 7=a89983
        palette = 8=918274
        palette = 9=fb4934
        palette = 10=b8ba26
        palette = 11=f9bc2f
        palette = 12=82a597
        palette = 13=d3859a
        palette = 14=8ebf7c
        palette = 15=ebdbb1
      ''
      # ''
      #   # foreground and background
      #   foreground = ebdbb2
      #   background = 262626

      #   # color palette
      #   palette = 0=${config.colorScheme.palette.base00}
      #   palette = 1=${config.colorScheme.palette.base01}
      #   palette = 2=${config.colorScheme.palette.base02}
      #   palette = 3=${config.colorScheme.palette.base03}
      #   palette = 4=${config.colorScheme.palette.base04}
      #   palette = 5=${config.colorScheme.palette.base05}
      #   palette = 6=${config.colorScheme.palette.base06}
      #   palette = 7=${config.colorScheme.palette.base07}
      #   palette = 8=${config.colorScheme.palette.base08}
      #   palette = 9=${config.colorScheme.palette.base09}
      #   palette = 10=${config.colorScheme.palette.base0A}
      #   palette = 11=${config.colorScheme.palette.base0B}
      #   palette = 12=${config.colorScheme.palette.base0C}
      #   palette = 13=${config.colorScheme.palette.base0D}
      #   palette = 14=${config.colorScheme.palette.base0E}
      #   palette = 15=${config.colorScheme.palette.base0F}
      # ''
    ];
  };
}
