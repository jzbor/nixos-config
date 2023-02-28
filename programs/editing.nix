{ config, pkgs, options, programs, ... }:

{
  environment.systemPackages = with pkgs; [
    audacity
    gimp
    libsForQt5.kdenlive
  ];
}
