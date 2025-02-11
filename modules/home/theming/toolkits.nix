{ pkgs, ... }:

let
  cursorTheme = "capitaine-cursors-white";
  cursorPackage = pkgs.capitaine-cursors;
  gtkTheme = "Orchis-Yellow-Dark-Compact";
  gtkPackage = pkgs.orchis-theme;
  iconTheme = "Numix-Circle";
  iconPackage = pkgs.numix-icon-theme-circle;
in {
  # Application Theming
  gtk = {
    enable = true;
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

  home.pointerCursor = {
    name = cursorTheme;
    package = cursorPackage;
    gtk.enable = true;
    x11.enable = true;
    size = 16;
  };

  #home.file.".icons/default/cursors" = {
  #  recursive = true;
  #  source = "${cursorPackage}/share/icons/${cursorTheme}/cursors";
  #};
}

