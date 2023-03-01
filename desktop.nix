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
      touchpad.naturalScrolling = true;
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

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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
      chromium
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
      gnome.simple-scan
      mpv
      nextcloud-client
      pcmanfm
    ];

  programs.gnome-disks.enable = true;
  programs.kdeconnect.enable = true;
  programs.nm-applet.enable = true;
  programs.seahorse.enable = true;
  programs.system-config-printer.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # Enable DRM content on Chromium
  nixpkgs.config.chromium.enableWideVine = true;

  # Firefox
  programs.firefox = {
    enable = true;
    policies = {
      DisablePocket = true;
      DisableFormHistory = true;
      EnableTrackingProtection = true;
      Cookies = {
        AcceptThirdParty = "never";
        RejectTracker = true;
      };
      SearchEngines = {
        Default = "DuckDuckGo";  # does not seem to be working
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
    };
  };
  # Enable new input backend
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  # Gnome
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
}
