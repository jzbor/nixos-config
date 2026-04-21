{ pkgs, lib, config, inputs, ... }:

with lib;
let
  mangowm = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cfg = config.jzbor-system.de.mangowm;
in {
  options.jzbor-system.de.mangowm = {
    enable = mkEnableOption "Enable mangowm desktop environment";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mangowm
      waybar
      wdisplays
      wev
    ];

    xdg.portal = {
      enable = lib.mkDefault true;

      config = {
        mango = {
          default = [
            "gtk"
            ];
          # except those
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.ScreenShot" = ["wlr"];

          # wlr does not have this interface
          "org.freedesktop.impl.portal.Inhibit" = [];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];

      wlr.enable = true;

      configPackages = [ mangowm ];
    };

    programs.xwayland.enable = true;

    services = {
      displayManager.sessionPackages = [ mangowm ];
    };
  };
}
