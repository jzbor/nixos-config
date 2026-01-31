{ config, pkgs, lib, inputs, system, ... }:

with lib;
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
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
      TERMINAL = "buttermilk";
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
      gcc
      inputs.nie.packages.${system}.default
      inputs.nix-sweep.packages.${system}.default
      lazygit
      librespeed-cli
      lucky-commit
      nil
      nix-tree
      powertop
      rustup
      tealdeer
      tinymist
      tree
      unzip
      uutils-coreutils-noprefix
      xournalpp
      zip
    ];

    programs.zsh.enable = true;

    programs.neovim.enable = true;
    programs.neovim.extraPackages = with pkgs; [ gcc ];
    jzbor-home.programs.vis.enable = true;

    # Management of XDG base directories
    xdg.enable = true;

    jzbor-home.programs.iamb.enable = true;
    jzbor-home.programs.toro.enable = true;

    services.udiskie.enable = true;
    jzbor-home.programs.nix-sweep.enable = true;

    # Add desktop entry for signal
    xdg.desktopEntries.signal-desktop = {
      name = "Signal Desktop";
      genericName = "Messenger";
      exec = "signal-desktop";
      icon = "signal-desktop";
      terminal = false;
      categories = [ "Application" "Network" ];
    };

    # Add desktop entry for set-wallpaper
    xdg.desktopEntries.set-wallpaper = {
      name = "Set Wallpaper";
      exec = "set-wallpaper %f";
      icon = "wallpaper";
      terminal = false;
      categories = [ "Utility" ];
      mimeType = [ "image/bmp" "image/jpeg" "image/gif" "image/png" "image/tiff" "image/x-bmp" "image/x-ico" "image/x-png" "image/webp" ];
    };
  };
}
