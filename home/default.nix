{ config, pkgs, nix-colors, lib, ... }:

with lib;
{
  imports = [
    nix-colors.homeManagerModule
    ./desktop
    ./features
    ./programs
    ./scripts
    ./theming
  ];

  config = {
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
      librespeed-cli
      nil
      powertop
      tealdeer
      tree
      unzip
      uutils-coreutils-noprefix
      zip
      cliflux
    ];

    programs.zsh.enable = true;

    programs.neovim.enable = true;

    # Replace command-not-found with nix-index
    programs.nix-index.enable = true;

    # Management of XDG base directories
    xdg.enable = true;
  };
}
