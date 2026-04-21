{ pkgs, lib, config, inputs, ... }:

with lib;
let
  cfg = config.jzbor-home.desktop;
in {
  imports = [
    ./marswm.nix
    ./mangowm.nix
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
    jzbor-home.desktop.mangowm.enable = true;

    home.packages = with pkgs; [
      gthumb
      inputs.parcels.packages.${pkgs.stdenv.hostPlatform.system}.foliot
      pwvucontrol
      thunar
      xarchiver

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
      buttermilk.enable = true;
      marswm.enable = true;
      touchegg.enable = true;
      xmenu.enable = true;
    };

    # Services
    services.gnome-keyring.enable = true;
    services.gpg-agent.enable = true;
    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Set default applications
    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications =
      let
        imageViewers = [ "org.gnome.gThumb.desktop" ];
        fileBrowsers = [ "thunar.desktop" "pcmanfm.desktop" ];
        pdfReaders = [ "org.pwmt.zathura.desktop" "org.gnome.Evince.desktop" ];
      in {
        "inode/directory" = fileBrowsers;

        "image/gif" = imageViewers;
        "image/jpeg" = imageViewers;
        "image/png "= imageViewers;
        "image/svg" = imageViewers;
        "image/webp" = imageViewers;

        "application/pdf" = pdfReaders;
    };

    # enable fontconfig and make fonts discoverable
    fonts.fontconfig.enable = true;
  };
}

