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
      # TODO restore once https://github.com/NixOS/nixpkgs/pull/326444 is merged
      #lollypop
      vlc
      mpv
    ] ++ (if cfg.dvdSupport then [
      libdvdcss
      libdvdnav
      libdvdread
    ] else []);
  };
}
