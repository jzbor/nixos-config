{ config, pkgs, nix-colors, lib, ... }: {
  imports = [
    nix-colors.homeManagerModule
    ./scripts

    ./desktop
    ./desktop/mars.nix

    ./programs/neovim
    ./programs/zsh
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "jzbor";
    homeDirectory = "/home/jzbor";
    stateVersion = "22.11";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "${pkgs.buttermilk}/bin/buttermilk";
  };

  home.file = {
    Documents.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Documents";
    Music.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Music";
    Pictures.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Pictures";
  };

  home.packages = with pkgs; [
    bat
    btop
    foliot
    librespeed-cli
    nixd
    okular
    powertop
    scrcpy
    tealdeer
    tree
    typst
    typst-lsp
    unzip
    uutils-coreutils-noprefix
    yt-dlp
    zip

    # fonts
    cascadia-code
    fira-code
    fira-code-symbols
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  # Replace command-not-found with nix-index
  programs.nix-index.enable = true;

  # enable fontconfig and make fonts discoverable
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.home-manager.path = lib.mkForce "$HOME/Programming/Nix/home-config";

  # Management of XDG base directories
  xdg.enable = true;
}
