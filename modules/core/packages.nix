{ config, pkgs, ... }:

{
  # Available shells
  environment.shells = with pkgs; [
    bash
    dash
    zsh
  ];

  # Install some packages
  environment.systemPackages = with pkgs; [
    bash
    cryptsetup
    curl
    fd
    glances
    lm_sensors
    ncdu
    neofetch
    nix-index
    ripgrep
    smartmontools
    tmux
    wget
    zsh
  ];

  # Programs
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
}

