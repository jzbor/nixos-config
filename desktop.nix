{ lib, config, pkgs, ... }:

{
  services.xserver = {
    # Enable XServer
    enable = true;

    # Wallpaper
    desktopManager.wallpaper.mode = "fill";

    # Touch and mouse input
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };

    # Keyboard layout
    layout = "us,de";
    xkbOptions = "caps:escape_shifted_capslock,altwin:swap_alt_win,grp:lwin_switch";
  };

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      hplipWithPlugin
      samsung-unified-linux-driver
      splix
    ];
  };




  # Xfce
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "marswm";
      start = "marswm & buttermilk";
    }
    {
      manage = "desktop";
      name = "pademelon";
      start = "pademelon-daemon";
    }
  ];

  # Desktop applications
  environment.systemPackages =
    with pkgs;
    [
      arandr
      buttermilk
      dmenu
      gparted
      lxappearance
      marswm
      neofetch
      numix-icon-theme-circle
      orchis-theme
      pademelon
      picom
      rofi
      xmenu
    ] ++ [ # User applications
      firefox
      gnome.gnome-disk-utility
      gnome.simple-scan
      mpv
      pcmanfm
    ];



  # Gnome
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
}
