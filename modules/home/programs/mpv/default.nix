{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.programs.mpv;
in mkIf cfg.enable {
  programs.mpv.package = pkgs.mpv.override {
    scripts = with pkgs.mpvScripts; [
      inhibit-gnome
    ] ++ [
      (pkgs.callPackage ./scripts/reload.nix {})
    ];
  };

  programs.mpv.config = {
    hwdec = "auto-safe";
    vo = "gpu";
    profile = "gpu-hq";
    #osc = "no";  # required for youtube-quality script
    idle = "yes";
    force-window = "yes";
    ytdl-format = "bestvideo[height<=?1080][fps<=?60]+bestaudio/best";
  };
}
