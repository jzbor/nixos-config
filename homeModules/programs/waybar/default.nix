{ pkgs, lib, config, inputs, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.waybar;
in {
  options.jzbor-home.programs.waybar = {
    enable = mkEnableOption "Install waybar";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
      libnotify
      inputs.laptopctl.packages."${pkgs.stdenv.hostPlatform.system}".default
    ];

    xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
    xdg.configFile."waybar/style.css".text = import ./style.nix config;
  };
}
