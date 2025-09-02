{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.iamb;
in {
  options.jzbor-home.programs.iamb = {
    enable = mkEnableOption "Install iamb matrix client";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      iamb
    ];

    xdg.configFile."iamb/config.toml".source = ./config.toml;
  };
}
