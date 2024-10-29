{ pkgs, ... }:

{
  environment.packages = with pkgs; [
    vim
    coreutils
    bashInteractive
    cacert
  ];
  system.stateVersion = "24.05";

  terminal.colors = {
    background = "#FFFFFF";
    foreground = "#000000";
    cursor = "#000000";
  };
}
