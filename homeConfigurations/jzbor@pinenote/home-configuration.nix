{ self, pkgs, system, inputs, ... }:

with pkgs.lib;
{
  imports = [
    ../../homeModules/programs
  ];

  home.packages = with pkgs; [
    nix-tree
  ];

  home.stateVersion = "25.11";
  home.username = "jzbor";
  home.homeDirectory = "/home/jzbor";

  jzbor-home.programs.vis.enable = true;
  jzbor-home.programs.nix-sweep.enable = true;
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.zsh.enable = true;
}
