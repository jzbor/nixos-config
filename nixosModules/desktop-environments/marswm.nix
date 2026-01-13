{ pkgs, lib, config, inputs, ... }:

with lib;
let
  cfg = config.jzbor-system.de.marswm;
in {
  imports = [
    inputs.marswm.nixosModules.default
  ];

  options.jzbor-system.de.marswm = {
    enable = mkEnableOption "Enable marswm desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.marswm.enable = true;
    services.xserver.enable = true;

    # Installed programs for marswm environment
    programs.light.enable = true;
    programs.nm-applet.enable = true;
    environment.systemPackages = with pkgs; [
      arandr
      ghostty
      dmenu
      lxappearance
      picom
      rofi
      xfce4-notifyd
      xmenu
    ];

    services.touchegg.enable = true;

    services.xserver.displayManager.session = [
      {
        manage = "desktop";
        name = "marswm-dev";
        start = "mv -f ~/.marswm.log ~/.marswm.log.old; RUST_BACKTRACE=1 ~/Programming/Rust/marswm/target/debug/marswm > ~/.marswm.log 2>&1";
      }
    ];
  };
}
