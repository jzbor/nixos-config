{ pkgs, ... }: {
  imports = [
    ../home/programs/neovim
  ];

  programs.neovim.enable = true;

  home = {
    username = "jzbor";
    homeDirectory = "/home/jzbor";
    stateVersion = "24.11";

    packages = with pkgs; [
      tealdeer
      nix-tree
    ];
  };
}
