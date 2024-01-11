{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.editing;
  # Editing domains with their default "enabled" setting
  domains = {
    images = true;
    audio = false;
    video = false;
  };
  defaultPackages = {

    common = with pkgs; [];

    images = with pkgs; [
      gimp
    ];

    audio = with pkgs; [
      audacity
    ];

    video = with pkgs; [
      libsForQt5.kdenlive
    ];

  };
in {
  options.jzbor-system.features.editing = {
    enable = mkOption {
      type = bool;
      description = "Enable editing feature";
      default = config.jzbor-system.features.enableDesktopDefaults;
    };
  } // (mapAttrs (domain: enabled: mkOption {
    type = bool;
    description = "Enable ${name} editing packages";
    default = enabled;
  }) domains);

  config = mkIf cfg.enable {
    environment.systemPackages = defaultPackages.common ++ (foldr (a: b: a ++ b) [] (
      map (x: if cfg."${x}" then defaultPackages."${x}" else []) (attrNames domains)
      ));
  };
}
