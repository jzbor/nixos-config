{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.input;
in {
  options.jzbor-system.features.input = {
    enable = mkOption {
      type = bool;
      description = "Enable input system";
      default = config.jzbor-system.features.enableBaseFeatures;
    };

    kbdLayout = mkOption {
      type = str;
      description = "Keyboard layout";
      default = "us,de";
    };

    swapAltWin = mkOption {
      type = bool;
      description = "Swap Alt and Win keys";
      default = true;
    };

    shiftEscape = mkOption {
      type = bool;
      description = "Use Shift key as Escape";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.libinput = {
      enable = true;

      # Touch input
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        middleEmulation = true;
        clickMethod = "clickfinger";
        tappingDragLock = false;
      };
    };

    # Keyboard layout
    services.xserver = {
      layout = cfg.kbdLayout;
      xkbOptions = concatStringsSep "," ([] ++ (if cfg.shiftEscape then [ "caps:escape_shifted_capslock" ] else [])
                                            ++ (if cfg.swapAltWin then [ "altwin:swap_alt_win" "grp:lwin_switch"] else []));
    };
  };
}
