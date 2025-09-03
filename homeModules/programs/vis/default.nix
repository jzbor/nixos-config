{ pkgs, lib, config, inputs, system, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.vis;
in {
  options.jzbor-home.programs.vis = {
    enable = mkEnableOption "Install and setup vis editor";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fzf
      inputs.parcels.packages.${system}.vis-unstable
    ];

    xdg.configFile."vis/visrc.lua".source = ./files/visrc.lua;
    xdg.configFile."vis/themes/seoulbones.lua".source = ./files/seoulbones.lua;
  };
}
