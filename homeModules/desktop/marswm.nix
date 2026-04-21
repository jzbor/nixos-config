{ pkgs, lib, config, system, inputs, ... }@attrs:

with lib;
let
  cfg = config.jzbor-home.desktop.marswm;
  lockScript = pkgs.writeScriptBin "lock-screen-x11" ''
    ${pkgs.playerctl}/bin/playerctl pause -a
    ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 100 2
  '';
  # lockScript = pkgs.writeScriptBin "lock-screen-x11" "${pkgs.lightdm}/bin/dm-tool lock";
  # lockScript = pkgs.writeScriptBin "lock-screen-x11" "${pkgs.i3lock}/bin/i3lock";
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
      xclip
      xev
      xkill
      xprop

      lockScript
    ];

    services.picom.enable = true;

    services.screen-locker = {
      enable = true;
      xautolock.enable = false;  # time based locking
      lockCmd = "${lockScript}/bin/lock-screen-x11";

      # disable automatic screen locking
      inactiveInterval = 10000;
      xss-lock.screensaverCycle = 10000;
    };

    xdg.desktopEntries = {
      lock-screen-x11 = {
        name = "Lock Screen (X11)";
        exec = "lock-screen-x11";
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

