
{ config, pkgs, options, programs, ... }:

{
  environment.systemPackages = with pkgs; [
    chromium
    lollypop
    vlc
  ];

  # Enable DRM content on Chromium
  nixpkgs.config.chromium.enableWideVine = true;
}
