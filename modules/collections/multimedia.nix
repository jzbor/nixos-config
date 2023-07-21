
{ config, pkgs, options, programs, ... }:

{
  environment.systemPackages = with pkgs; [
    # chromium
    # libdvdcss   # DVD decryption
    # libdvdnav   # DVD navigation
    # libdvdread  # DVD reading
    lollypop
    vlc
  ];

  # Enable DRM content on Chromium
  nixpkgs.config.chromium.enableWideVine = true;
}
