{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./dev-shell.nix {})
    (pkgs.callPackage ./fman.nix {})
    (pkgs.callPackage ./mars-help.nix {})
    (pkgs.callPackage ./mars-startup.nix {})
    (pkgs.callPackage ./mars-status.nix {})
    (pkgs.callPackage ./nix-maintenance.nix {})
    (pkgs.callPackage ./open-document.nix {})
    (pkgs.callPackage ./replay-area.nix {})
    (pkgs.callPackage ./riot.nix {})
    (pkgs.callPackage ./screencast.nix {})
    (pkgs.callPackage ./spotify-wm-compat.nix {})
    (pkgs.callPackage ./switch-dir.nix {})
    (pkgs.callPackage ./wallpaper-daemon.nix {})
    (pkgs.callPackage ./xdg-xmenu.nix {})

    # Packages shared by multiple scripts (to avoid collisions
    pkgs.python3
  ];
}
