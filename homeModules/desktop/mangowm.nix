{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.desktop.mangowm;
  lockScript = pkgs.writeScriptBin "lock-screen-wl" ''
    ${pkgs.playerctl}/bin/playerctl pause -a
    ${pkgs.swaylock}/bin/swaylock -fc ${config.colorScheme.palette.base00}
  '';
in {
  options.jzbor-home.desktop.mangowm = {
    enable = mkEnableOption "Enable mangowm desktop";
  };

  config = mkIf cfg.enable {
    jzbor-home.programs.buttermilk.enable = true;
    jzbor-home.programs.mangowm.enable = true;
    jzbor-home.programs.waybar.enable = true;
    programs.rofi.enable = true;

    home.packages = with pkgs; [
      wl-clipboard
      swaybg
      swaylock
      wev
      slurp
      grim

      lockScript
    ];

    xdg.desktopEntries = {
      lock-screen-wl = {
        name = "Lock Screen (Wayland)";
        exec = "lock-screen-wl";
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
  };
}

