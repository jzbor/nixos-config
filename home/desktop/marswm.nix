{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.desktop.marswm;
  # lockScript = pkgs.writeScriptBin "lock-screen" "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 100 2";
  lockScript = pkgs.writeScriptBin "lock-screen" "${pkgs.lightdm}/bin/dm-tool lock";
in {
  options.jzbor-home.desktop.marswm = {
    enable = mkEnableOption "Enable marswm desktop";
  };

  config = mkIf cfg.enable {
    jzbor-home.programs.buttermilk.enable = true;
    jzbor-home.programs.marswm.enable = true;
    jzbor-home.programs.skippy-xd.enable = true;
    jzbor-home.programs.touchegg.enable = true;
    jzbor-home.programs.xmenu.enable = true;
    programs.rofi.enable = true;

    home.packages = with pkgs; [
      gthumb
      gnome.file-roller
      pavucontrol
      pcmanfm
      xclip
      xorg.xev
      xorg.xkill
      xorg.xprop

      lockScript
    ];

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


    services.gnome-keyring.enable = true;
    services.gpg-agent.enable = true;
    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;

    services.picom = {
      enable = true;
      package = pkgs.picom-next;
      backend = "glx";
      vSync = true;
    };

    services.screen-locker = {
      enable = true;
      xautolock.enable = false;  # time based locking
      lockCmd = "${lockScript}/bin/lock-screen";

      # disable automatic screen locking
      inactiveInterval = 10000;
      xss-lock.screensaverCycle = 10000;
    };
    xdg.desktopEntries.lock-screen = {
      name = "Lock Screen";
      exec = "lock-screen";
      categories = [ "System" "Utility" ];
      icon = "system-lock-screen";
    };

    xsession = {
      enable = true;
      #windowManager.command = "marswm";
      initExtra = ''
        command -v solaar > /dev/null && solaar -w hide &
      '';
      #windowManager.command = "${pkgs.marswm}/bin/marswm";
      #initExtra = "${pkgs.buttermilk}/bin/buttermilk &";
    };
  };
}

