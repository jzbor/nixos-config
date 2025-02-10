{ config, pkgs, lib, inputs, ... }:

with lib;
{
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.nix-index-database.hmModules.nix-index
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
      TERMINAL = "${pkgs.ghostty}/bin/ghostty";
    };

    home.file = {
      Documents.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Documents";
      Music.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Music";
      Pictures.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Pictures";
    };

    home.packages = with pkgs; [
      attic-client
      bat
      btop
      cliflux
      gcc
      librespeed-cli
      nil
      powertop
      rustup
      tealdeer
      tree
      unzip
      uutils-coreutils-noprefix
      zip
      nix-sweep
      nix-tree
    ];

    # garbage collection
    nix.package = pkgs.nix;
    nix.gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };

    programs.zsh.enable = true;

    programs.neovim.enable = true;
    programs.neovim.extraPackages = with pkgs; [ gcc ];

    # Management of XDG base directories
    xdg.enable = true;

    jzbor-home.programs.iamb.enable = true;

    services.udiskie.enable = true;
  };
}
