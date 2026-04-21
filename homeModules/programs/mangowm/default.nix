{ pkgs, lib, config, inputs, ... }:

with lib;
let
  mangowm = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cfg = config.jzbor-home.programs.mangowm;
in {
  options.jzbor-home.programs.mangowm = {
    enable = mkEnableOption "Install mangowm window manager";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mangowm

      # required by key bindings
      libcanberra-gtk3
      maim
      playerctl
      pulseaudio
      wl-clipboard
    ];

    xdg.configFile."mango/config.conf".text = concatStringsSep "\n\n" [
      (readFile ./startup.conf)
      (readFile ./tweaks.conf)
      (readFile ./animations.conf)
      (readFile ./input.conf)
      (readFile ./bindings.conf)
      (readFile ./rules.conf)
      (import ./theming.nix config)
    ];
  };
}
