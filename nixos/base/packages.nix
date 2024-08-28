{ pkgs, ... }:


let
  graphicalPackages = with pkgs; [
    gparted
    mpv
    nextcloud-client
    pcmanfm
    zathura
    superTuxKart
  ];
  systemUtilPackages = with pkgs; [
    cryptsetup
    glances
    lm_sensors
    ncdu
    neofetch
    smartmontools
    glxinfo
    libva-utils
  ];
  cliPackages = with pkgs; [
    curl
    fd
    nix-index
    ripgrep
    tmux
    wget
    neofetch
  ];
in {
  # Available shells
  environment.shells = with pkgs; [
    bash
    dash
    zsh
  ];

  # Install some packages
  environment.systemPackages = graphicalPackages ++ systemUtilPackages ++ cliPackages;

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
}

