{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.buttermilk;
  palette = config.colorScheme.palette;
in {
  options.jzbor-home.programs.kermit = {
    enable = mkEnableOption "Install kermit terminal";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kermit-terminal
    ];

    xdg.configFile."kermit.conf".text = builtins.concatStringsSep "\n" [
      (builtins.readFile ./kermit.conf)
      ''
        # Foreground color
        foreground         0xebdbb2
        foreground_bold    0xebdbb2

        # Cursor color
        cursor             0xebdbb2
        cursor_foreground  0xebdbb2

        # Background color
        background         0x262626

        color0 0x282828
        color1 0xcc231c
        color2 0x97971a
        color3 0xd69921
        color4 0x448587
        color5 0xb16285
        color6 0x679c69
        color7 0xa89983
        color8 0x918274
        color9 0xfb4934
        color10 0xb8ba26
        color11: 0xf9bc2f
        color12: 0x82a597
        color13: 0xd3859a
        color14: 0x8ebf7c
        color15: 0xebdbb1
      ''
      # ''
      # color0 0x${config.colorScheme.palette.base00}
      # color1 0x${config.colorScheme.palette.base01}
      # color2 0x${config.colorScheme.palette.base02}
      # color3 0x${config.colorScheme.palette.base03}
      # color4 0x${config.colorScheme.palette.base04}
      # color5 0x${config.colorScheme.palette.base05}
      # color6 0x${config.colorScheme.palette.base06}
      # color7 0x${config.colorScheme.palette.base07}
      # color8 0x${config.colorScheme.palette.base08}
      # color9 0x${config.colorScheme.palette.base09}
      # color10 0x${config.colorScheme.palette.base0A}
      # color11 0x${config.colorScheme.palette.base0B}
      # color12 0x${config.colorScheme.palette.base0C}
      # color13 0x${config.colorScheme.palette.base0D}
      # color14 0x${config.colorScheme.palette.base0E}
      # color15 0x${config.colorScheme.palette.base0F}
      # ''
    ];
  };
}
