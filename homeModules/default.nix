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
      TERMINAL = "ghostty";
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
      lazygit
      librespeed-cli
      nil
      nix-tree
      inputs.nix-sweep.packages.${system}.default
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
  };
}
