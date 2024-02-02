
{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.skippy-xd;
in {
  options.jzbor-home.programs.skippy-xd = {
    enable = mkEnableOption "Install skippy-xd";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ skippy-xd ];

    xdg.configFile."skippy-xd/skippy-xd.rc".text =
      ''
        [general]

        # layout = xd (traditional layout), or boxy (=grouped #1)
        layout = xd

        distance = 50
        useNetWMFullscreen = true
        ignoreSkipTaskbar = true
        updateFreq = 200.0

        # set = 0 to switch off animations
        animationDuration = 0

        lazyTrans = false
        pipePath = /tmp/skippy-xd-fifo

        # Move the mouse cursor to the next highlighted window, straight after launching skippy
        movePointerOnStart = true

        # Move the mouse cursor over the currently highlighted window, when using the keyboard to navigate between windows
        movePointerOnSelect = false

        # After activating the selected window, the skippy window picker is dissmissed. Then move mouse cursor to the center of the selected window.
        # Otherwise (if false), the mouse cursor will remain in the location where it was at the time when skippy was dismissed.
        movePointerOnRaise = false

        switchDesktopOnActivate = false
        includeFrame = true
        allowUpscale = true
        showAllDesktops = true
        cornerRadius = 0
        preferredIconSize = 64
        showIconsOnThumbnails = true
        iconFillSpec = orig mid mid #00FFFF
        fillSpec = orig mid mid #FFFFFF
        background =

        [xinerama]
        showAll = true

        [normal]
        tint = white
        tintOpacity = 0
        opacity = 255

        [highlight]
        tint = #${config.colorScheme.palette.base02}
        tintOpacity = 64
        opacity = 255

        [shadow]
        tint = black
        tintOpacity = 64
        opacity = 255

        [tooltip]
        show = true
        followsMouse = true
        offsetX = 20
        offsetY = 20
        align = left
        border = #${config.colorScheme.palette.base0F}
        background = #${config.colorScheme.palette.base00}
        opacity = 128
        text = #${config.colorScheme.palette.base0F}
        textShadow = black
        font = FiraCode Nerd Font 14:weight=bold

        [bindings]
        miwMouse1 = focus
        miwMouse2 = close-ewmh
        miwMouse3 = iconify
        keysUp = Up w
        keysDown = Down s
        keysLeft = Left a
        keysRight = Right d
        keysPrev = p b
        keysNext = n f
        keysExitCancelOnPress = Escape BackSpace x q
        keysExitCancelOnRelease =
        keysExitSelectOnPress = Return space
        keysExitSelectOnRelease = Super_L Super_R Alt_L Alt_R ISO_Level3_Shift
        keysReverseDirection = Tab
        modifierKeyMasksReverseDirection = ShiftMask ControlMask
      '';
  };
}
