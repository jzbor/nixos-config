{ pkgs, lib, config, inputs, system, ... }:

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
      inputs.parcels.packages.${pkgs.stdenv.hostPlatform.system}.foliot
      scrcpy
      typst
      yt-dlp

      # fonts
      annotation-mono
      cascadia-code
      fira-code
      fira-code-symbols
      hermit
      liberation_ttf
      libertine
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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

