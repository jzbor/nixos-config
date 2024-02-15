{ lib, ... }:

with lib;
with types;
{
  imports = [
  ];

  options.jzbor-home.features = {
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
