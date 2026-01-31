{ pkgs, lib, config, inputs, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.buttermilk;
in {
  options.jzbor-home.programs.buttermilk = {
    enable = mkEnableOption "Install buttermilk terminal";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.parcels.packages.${pkgs.stdenv.hostPlatform.system}.buttermilk
    ];

    xdg.configFile."buttermilk/buttermilk.conf".source = ./buttermilk.conf;
  };
}
