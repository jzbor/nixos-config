{ inputs, system, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.nix-sweep;
in {
  options.jzbor-home.programs.nix-sweep = {
    enable = mkEnableOption "Install and set up nix-sweep";
  };

  imports = [ inputs.nix-sweep.homeModules.default ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.nix-sweep.packages.${system}.default
    ];

    services.nix-sweep = {
      enable = true;
      interval = "daily";
      removeOlder = "30d";
      keepMax = 30;
      keepMin = 5;
    };
  };
}
