{ pkgs, lib, config, perSystem, ... }:

with lib;
let
  cfg = config.jzbor-home.desktop;
in {
  imports = [
    ./marswm.nix
  ];

  options.jzbor-home.desktop = {
    enable = mkOption {
      type = types.bool;
      description = "Enable graphical UI applications and services";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    jzbor-home.desktop.marswm.enable = true;

    home.packages = with pkgs; [
      perSystem.parcels.foliot
      scrcpy
      typst
      yt-dlp

      # fonts
      cascadia-code
      fira-code
      fira-code-symbols
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      libertine
    ];

    # Programs
    programs = {
      firefox.enable = true;
      mpv.enable = true;
      rofi.enable = true;
      thunderbird.enable = true;
    };
    jzbor-home.programs = {
      captive-browser.enable = true;
      ghostty.enable = true;
      marswm.enable = true;
      touchegg.enable = true;
      xmenu.enable = true;
    };

    # Services
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # enable fontconfig and make fonts discoverable
    fonts.fontconfig.enable = true;
  };
}

