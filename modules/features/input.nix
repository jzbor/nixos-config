{ config, pkgs, ... }:

{
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
    layout = "us,de";
    xkbOptions = "caps:escape_shifted_capslock,altwin:swap_alt_win,grp:lwin_switch";
  };
}
