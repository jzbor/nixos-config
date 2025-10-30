{ pkgs, ... }:


let
  graphicalPackages = with pkgs; [
    gnome-disk-utility
    mpv
    nextcloud-client
    zathura
  ];
  systemUtilPackages = with pkgs; [
    cryptsetup
    dysk
    glxinfo
    libva-utils
    lm_sensors
    ncdu
    neofetch
    smartmontools
  ];
  cliPackages = with pkgs; [
    curl
    fd
    ripgrep
    tmux
    wget
    neofetch
  ];
  manPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];
in {
  # Available shells
  environment.shells = with pkgs; [
    bash
    dash
    zsh
  ];

  # Install some packages
  environment.systemPackages = graphicalPackages ++ systemUtilPackages ++ cliPackages ++ manPackages;

  # Programs
  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.less.enable = true;
  programs.traceroute.enable = true;
  programs.zsh.enable = true;

  # Default Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # DBus implementation
  services.dbus.implementation = "broker";

  # Enable PolicyKit for access management
  security.polkit.enable = true;

  # Required for nextcloud
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

  # Enable dev documentation for installed packages
  documentation.dev.enable = true;

}

