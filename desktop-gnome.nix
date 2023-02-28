{ lib, config, pkgs, ... }:

{
  # Gnome
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Remove unwanted packages
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gedit
    epiphany
    geary
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  # Add extensions and additional gnome packages
  environment.systemPackages = (with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
  ]) ++ (with pkgs.gnome; [
    gnome-tweaks
  ]) ++ (with pkgs; [
    gnome-firmware
  ]);
}
