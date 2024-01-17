{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.programs.neovim;
in mkIf cfg.enable {
  # Add symlinks to vi and vim
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Enable Python 3 provider
  programs.neovim.withPython3 = true;

  xdg.configFile."nvim".source = ./files;
}
