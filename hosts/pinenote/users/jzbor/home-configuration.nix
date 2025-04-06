{ inputs, flake, pkgs, perSystem, ... }:

let
  scripts = import ../../../../modules/home/scripts/packages.nix { inherit inputs pkgs perSystem; };
  waybar-wrapper = pkgs.writeShellApplication {
    name = "waybar-wrapper";
    text = ''
      PATH=$HOME/.nix-profile/bin:$PATH ${pkgs.waybar}/bin/waybar >"$HOME/waybar_log" 2>&1
    '';
  };
  nix-path-wrapper = pkgs.writeShellApplication {
    name = "nix-path-wrapper";
    text = ''
      export PATH=$HOME/.nix-profile/bin:$PATH
      "$@"
    '';
  };
  pn-scripts = pkgs.symlinkJoin {
    name = "pn-scripts";
    paths = [
      (pkgs.writeShellApplication {
        name = "pn-eink-status";
        text = pkgs.lib.readFile ./pn-eink-status.sh;
      })
      (pkgs.writeShellApplication {
        name = "pn-lock-suspend";
        text = pkgs.lib.readFile ./pn-lock-suspend.sh;
      })
      (pkgs.writeShellApplication {
        name = "pn-wmenu";
        text = ''
          pkill -SIGUSR2 wvkbd-mobintl
          wmenu-run -N ffffff -n 000000 -M 000000 -m ffffff -S 000000 -s ffffff -f 'mono 12' -p run -l 10
          pkill -SIGUSR1 wvkbd-mobintl
        '';
      })
    ];
  };
in {
  imports = [
    flake.homeModules.programs
  ];

  programs.neovim.enable = true;

  home = {
    username = "jzbor";
    homeDirectory = "/home/jzbor";
    stateVersion = "24.11";

    packages = with pkgs; [
      attic-client
      brightnessctl
      pn-scripts
      fd
      librespeed-cli
      nerd-fonts.comic-shanns-mono
      nix-tree
      perSystem.parcels.peanutbutter
      perSystem.parcels.pinenotectl
      perSystem.parcels.nix-sweep
      ripgrep
      scripts.xdg-xmenu
      tealdeer
      waybar
      waybar-wrapper
      nix-path-wrapper
      xmenu
    ];

    file = {
      ".nixpkgs".source = inputs.nixpkgs;
      ".config/sway".source = ./files/sway;
      ".config/waybar".source = ./files/waybar;
      ".config/eink_menu".source = ./files/eink_menu;
      ".config/window_menu".source = ./files/window_menu;
    };
  };
}
