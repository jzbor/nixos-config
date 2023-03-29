{ lib, config, pkgs, ... }:

{
  imports = [
    ./environments/marswm.nix
    ./environments/gnome.nix

    ./modules/audio.nix
    ./modules/input.nix
    ./modules/printing.nix
    ./modules/theming.nix
    ./modules/wireless.nix

    ./programs/firefox.nix
  ];

  services.xserver.enable = true;

  # Desktop agnostic applications
  programs.firefox.enable = true;
  programs.gnome-disks.enable = true;
  programs.kdeconnect.enable = true;
  programs.seahorse.enable = true;
  programs.system-config-printer.enable = true;
  environment.systemPackages = with pkgs; [
    glxinfo
    gnome.simple-scan
    gparted
    libva-utils
    mpv
    neofetch
    nextcloud-client
    pcmanfm
  ];

  services.gnome.gnome-keyring.enable = true;

  # Display manager
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;

  # Enable PolicyKit for access management
  security.polkit.enable = true;

  # Desktop specific firewall ports
  networking.firewall.allowedTCPPorts = [
    57621  # spotify local device discovery
  ];

}
