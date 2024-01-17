{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.gaming;
  # Games and platforms
  games = {
    superTuxKart = true;
    steam = false;
  };
  defaultPackages = {
    superTuxKart = with pkgs; [
      superTuxKart
    ];
  };
in {
  options.jzbor-system.features.gaming = {
    enable = mkOption {
      type = bool;
      description = "Enable gaming feature";
      default = false;
    };
  } // (mapAttrs (game: enabled: mkOption {
    type = bool;
    description = "Enable ${name} game/platform";
    default = enabled;
  }) games);

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    programs.steam = mkIf cfg.steam {
      enable = true;
    };

    environment.systemPackages = (foldr (a: b: a ++ b) [] (
      map (x: if cfg."${x}" then (defaultPackages."${x}" or []) else []) (attrNames games)
      ));
  };
}
