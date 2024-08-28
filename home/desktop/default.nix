{ pkgs, lib, config, ... }:

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
      foliot
      neovide
      okular
      scrcpy
      typst
      typst-lsp
      yt-dlp

      # fonts
      cascadia-code
      fira-code
      fira-code-symbols
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
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
      kermit.enable = true;
      marswm.enable = true;
      skippy-xd.enable = true;
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

