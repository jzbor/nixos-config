{ config, pkgs, options, programs, ... }:

{
  # Documentation
  documentation.man.enable = true;
  documentation.doc.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    man-pages
    man-pages-posix
    nodePackages.pyright
    poetry
    python3
    rust-analyzer
    rustup
    valgrind
  ];
}
