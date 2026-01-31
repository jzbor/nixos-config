{ pkgs, lib, config, inputs, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.toro;
in {
  options.jzbor-home.programs.toro = {
    enable = mkEnableOption "Install toro task manager";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.toro.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."toro/config.toml".source = ./config.toml;
  };
}
