{ lib, ... }:

with lib;
with types;
{
  imports = [
    ./audio.nix
    ./coding.nix
    ./editing.nix
    ./gaming.nix
    ./input.nix
    ./multimedia.nix
    ./office.nix
    ./theming.nix
    ./wireless.nix
  ];

  options.jzbor-system.features = {
    enableDesktopDefaults = mkOption {
      type = bool;
      description = "Enable all default desktop modules";
      default = true;
    };

    enableBaseFeatures = mkOption {
      type = bool;
      description = "Enable the most basic features for personal devices (sound, input etc.)";
      default = true;
    };
  };

}
