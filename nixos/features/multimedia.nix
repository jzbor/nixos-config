{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.multimedia;
in {
  options.jzbor-system.features.multimedia = {
    enable = mkOption {
      type = bool;
      description = "Enable multimedia feature";
      default = config.jzbor-system.features.enableDesktopDefaults;
    };

    dvdSupport = mkOption {
      type = bool;
      description = "Enable DVD support";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lollypop
      mpv
    ] ++ (if cfg.dvdSupport then [
      vlc
      libdvdcss
      libdvdnav
      libdvdread
    ] else []);
  };
}
