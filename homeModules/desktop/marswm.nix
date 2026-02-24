{ pkgs, lib, config, system, inputs, ... }@attrs:

with lib;
let
  cfg = config.jzbor-home.desktop.marswm;
  lockScript = pkgs.writeScriptBin "lock-screen" ''
    ${pkgs.playerctl}/bin/playerctl pause -a
    ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 100 2
  '';
  # lockScript = pkgs.writeScriptBin "lock-screen" "${pkgs.lightdm}/bin/dm-tool lock";
  # lockScript = pkgs.writeScriptBin "lock-screen" "${pkgs.i3lock}/bin/i3lock";
  mkScript = script: "${(import ../scripts/packages.nix attrs).${script}}";
in {
  options.jzbor-home.desktop.marswm = {
    enable = mkEnableOption "Enable marswm desktop";
  };

  config = mkIf cfg.enable {
    jzbor-home.programs.buttermilk.enable = true;
    jzbor-home.programs.marswm.enable = true;
    jzbor-home.programs.touchegg.enable = true;
    jzbor-home.programs.xmenu.enable = true;
    programs.rofi.enable = true;

    home.packages = with pkgs; [
      # file-roller
      xarchiver
      gthumb
      pwvucontrol
      thunar
      xclip
      xev
      xkill
      xprop

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

    services.picom.enable = true;

    services.screen-locker = {
      enable = true;
      xautolock.enable = false;  # time based locking
      lockCmd = "${lockScript}/bin/lock-screen";

      # disable automatic screen locking
      inactiveInterval = 10000;
      xss-lock.screensaverCycle = 10000;
    };

    xdg.desktopEntries = {
      lock-screen = {
        name = "Lock Screen";
        exec = "lock-screen";
        categories = [ "System" "Utility" ];
        icon = "system-lock-screen";
      };
      suspend = {
        name = "Suspend";
        exec = "systemctl suspend";
        categories = [ "System" "Utility" ];
        icon = "starred";
      };
      poweroff = {
        name = "Poweroff";
        exec = "poweroff";
        categories = [ "System" "Utility" ];
        icon = "system-shutdowstarredn";
      };
    };

    xsession = {
      enable = true;
      initExtra = ''
        command -v solaar > /dev/null && solaar -w hide &
      '';
    };

    systemd.user.services.wallpaper-daemon = {
      Unit.Description = "Watch for configuration changes in the display";
      Install.WantedBy = [ "xsession.target" ];
      Service = {
        ExecStart = "${mkScript "wallpaper-daemon"}/bin/wallpaper-daemon";
      };
    };

    systemd.user.services.xrandr-daemon = {
      Unit.Description = "Watch for configuration changes in the display configuration and show options for reconfiguration";
      Install.WantedBy = [ "xsession.target" ];
      Service = {
        ExecStart = "${mkScript "xrandr-daemon"}/bin/xrandr-daemon";
      };
    };

    systemd.user.services.marsbar = {
      Unit.Description = "Bar for marswm desktop";
      Install.WantedBy = [ "xsession.target" ];
      Service = {
        ExecStart = "${inputs.parcels.packages.${system}.marswm}/bin/marsbar";
      };
    };

    systemd.user.services.touchegg = {
      Unit.Description = "Touch gesture deamon";
      Install.WantedBy = [ "xsession.target" ];
      Service = {
        ExecStart = "${pkgs.touchegg}/bin/touchegg";
      };
    };

    systemd.user.targets.xsession = {
      Unit.Description = "X11 server target";
    };
  };
}

