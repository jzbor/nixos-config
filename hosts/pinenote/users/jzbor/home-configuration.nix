{ flake, pkgs, perSystem, ... }:

{
  imports = [ flake.homeModules.programs ];

  programs.neovim.enable = true;

  home = {
    username = "jzbor";
    homeDirectory = "/home/jzbor";
    stateVersion = "24.11";

    packages = with pkgs; [
      tealdeer
      nix-tree
      perSystem.parcels.nix-sweep
      librespeed-cli
      fd
      ripgrep
    ];
  };
}
