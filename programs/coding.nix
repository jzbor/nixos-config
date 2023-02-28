{ config, pkgs, options, programs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    rust-analyzer
    rustup
    valgrind
  ];
}
