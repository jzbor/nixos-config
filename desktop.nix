{ lib, config, pkgs, ... }:

{
  # Enable XServer
  services.xserver.enable = true;

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

  # Default keyboard layout
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";

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
      mpv
      pcmanfm
    ];



  # Gnome
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
}
