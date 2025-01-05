{ pkgs, config, lib, ... }:

with lib;
with types;
let
  cfg = config.jzbor-system.features.theming;
in {
  options.jzbor-system.features.theming = {
    enable = mkOption {
      type = bool;
      description = "Enable system-wide theming";
      default = config.jzbor-system.features.enableDesktopDefaults;
    };

    installDefaultFonts = mkOption {
      type = bool;
      description = "Install default fonts";
      default = true;
    };

    cursor = {
      theme = mkOption {
        type = str;
        description = "Cursor theme";
        default = "capitaine-cursors-white";
      };
      package = mkOption {
        description = "Cursor package";
        default = pkgs.capitaine-cursors;
      };
    };

    gtk = {
      theme = mkOption {
        type = str;
        description = "GTK+ theme";
        default = "Orchis-Yellow-Dark-Compact";
      };
      package = mkOption {
        description = "GTK+ theme package";
        default = pkgs.orchis-theme;
      };
    };

    icons = {
      theme = mkOption {
        type = str;
        description = "Icon theme";
        default = "Numix-Circle";
      };
      package = mkOption {
        description = "Icon theme package";
        default = pkgs.numix-icon-theme-circle;
      };
    };

  };

  config = mkIf cfg.enable {
    # Fonts
    fonts.enableDefaultPackages = cfg.installDefaultFonts;

    # LightDM GTK greeter
    services.xserver.displayManager.lightdm.greeters.gtk = {
      theme = {
        name = cfg.gtk.theme;
        inherit (cfg.gtk) package;
      };
      iconTheme = {
        name = cfg.icons.theme;
        inherit (cfg.icons) package;
      };
      cursorTheme = {
        name = cfg.cursor.theme;
        inherit (cfg.cursor) package;
      };
    };
    services.xserver.displayManager.lightdm.background = pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath;

    # Make qt5 styling match gtk theme
    qt = {
      enable = true;
      platformTheme = "gtk2";
      style = "gtk2";
    };
  };
}
