{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.xwinmosaic;
in {
  options.jzbor-home.programs.xwinmosaic = {
    enable = mkEnableOption "Install xwinmosaic window viewer";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xwinmosaic
    ];

    xdg.configFile."xwinmosaic/config".source = ./config;

    xdg.configFile."xwinmosaic/colors".text = ''

      [colors]
      Buttermilk = #${config.colorScheme.palette.base01}
      Spotify = #${config.colorScheme.palette.base02}
      Pcmanfm = #${config.colorScheme.palette.base03}
      firefox = #${config.colorScheme.palette.base04}
      discord = #${config.colorScheme.palette.base05}
      mpv = #${config.colorScheme.palette.base06}

      thunderbird = #${config.colorScheme.palette.base0C}

      fallback = #${config.colorScheme.palette.base00}; ${config.colorScheme.palette.base00}; ${config.colorScheme.palette.base01}; ${config.colorScheme.palette.base02}; ${config.colorScheme.palette.base03}; ${config.colorScheme.palette.base04}; ${config.colorScheme.palette.base05}; ${config.colorScheme.palette.base06}; ${config.colorScheme.palette.base07};
    '';
  };
}
