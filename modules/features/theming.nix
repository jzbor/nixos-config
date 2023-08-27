
{ config, pkgs, ... }:

let
  cursorTheme = "Breeze_Snow";
  cursorPackage = pkgs.libsForQt5.breeze-qt5;
  gtkTheme = "Orchis-Yellow-Dark-Compact";
  gtkPackage = pkgs.orchis-theme;
  iconTheme = "Numix-Circle";
  iconPackage = pkgs.numix-icon-theme-circle;
in {
  # Fonts
  fonts.enableDefaultPackages = true;

  # LightDM GTK greeter
  services.xserver.displayManager.lightdm.greeters.gtk = {
    theme = {
      name = gtkTheme;
      package = gtkPackage;
    };
    iconTheme = {
      name = iconTheme;
      package = iconPackage;
    };
    cursorTheme = {
      name = cursorTheme;
      package = cursorPackage;
    };
  };

  # Make qt5 styling match gtk theme
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

}
