{ config, pkgs, lib, inputs, perSystem, ... }:

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
      perSystem.nix-sweep.default
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

    # garbage collection
    nix.package = perSystem.self.nix;
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
