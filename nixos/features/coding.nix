{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.coding;
  # Languages with their default "enabled" setting
  langs = {
    c = true;
    rust = true;
    python = false;
    android = false;
  };
  defaultPackages = {

    common = with pkgs; [
      gnumake
      man-pages
      man-pages-posix
    ];

    python = with pkgs; [
      poetry
      python3
    ];

    rust = with pkgs; [
      rust-analyzer
      rustup
    ];

    c = with pkgs; [
      clang
      gcc
      valgrind
    ];
  };
in {
  options.jzbor-system.features.coding = {
    enable = mkOption {
      type = bool;
      description = "Enable coding feature";
      default = config.jzbor-system.features.enableDesktopDefaults;
    };
  } // (mapAttrs (lang: enabled: mkOption {
    type = bool;
    description = "Enable ${name} development packages";
    default = enabled;
  }) langs);

  config = mkIf cfg.enable {
    documentation.man.enable = true;
    documentation.doc.enable = true;

    environment.systemPackages = defaultPackages.common ++ (foldr (a: b: a ++ b) [] (
      map (x: if cfg."${x}" then defaultPackages."${x}" else []) (attrNames langs)
      ));

    programs.adb.enable = cfg.android;
  };
}
