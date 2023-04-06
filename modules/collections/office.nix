{ config, pkgs, options, programs, ... }:

{
  environment.systemPackages = with pkgs; [
    libreoffice-fresh
  ];
}
