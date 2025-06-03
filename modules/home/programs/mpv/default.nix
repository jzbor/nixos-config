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

    # TODO: Remove as soon as fix is merged upstream: https://nixpkgs-tracker.jzbor.de/?pr=412889
    mpv = pkgs.mpv-unwrapped.override {
      libplacebo = pkgs.libplacebo.overrideAttrs {
        patches = [
          (pkgs.fetchpatch {
            name = "fix-shaders.patch";
            url = "https://github.com/haasn/libplacebo/commit/4c6d99edee23284f93b07f0f045cd660327465eb.patch";
            revert = true;
            hash = "sha256-zoCgd9POlhFTEOzQmSHFZmJXgO8Zg/f9LtSTSQq5nUA=";
          })
        ];
      };
    };
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
