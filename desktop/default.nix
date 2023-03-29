{ lib, config, pkgs, ... }:

{
  imports = [
    ./environments/marswm.nix
    ./environments/gnome.nix

    ./modules/wireless.nix
    ./modules/audio.nix
    ./modules/printing.nix
    ./modules/input.nix

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
    gnome.simple-scan
    gparted
    mpv
    neofetch
    nextcloud-client
    pcmanfm
  ];

  services.gnome.gnome-keyring.enable = true;

  # Make qt5 styling match gtk theme
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };
}
