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
      # rhythmbox  # TODO: read once https://nixpkgs-tracker.jzbor.de/?pr=418561 is in nixos-unstable
      mpv
    ] ++ (if cfg.dvdSupport then [
      vlc
      libdvdcss
      libdvdnav
      libdvdread
    ] else []);
  };
}
