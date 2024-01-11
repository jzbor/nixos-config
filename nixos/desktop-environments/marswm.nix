{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-system.de.marswm;
in {
  options.jzbor-system.de.marswm = {
    enable = mkEnableOption "Enable marswm desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    # Installed programs for marswm environment
    programs.light.enable = true;
    programs.nm-applet.enable = true;
    environment.systemPackages = with pkgs; [
      arandr
      buttermilk
      dmenu
      lxappearance
      marswm
      picom-next
      rofi
      xfce.xfce4-notifyd
      xmenu
    ];

    services.touchegg.enable = true;

    services.xserver.displayManager.session = [
      {
        manage = "desktop";
        name = "marswm";
        start = "marswm";
      }
      {
        manage = "desktop";
        name = "marswm-dev";
        start = "mv -f ~/.marswm.log ~/.marswm.log.old; ~/Programming/Rust/marswm/target/debug/marswm > ~/.marswm.log 2>&1";
      }
    ];
  };
}
