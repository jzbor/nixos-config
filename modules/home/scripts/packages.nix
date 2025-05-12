{ pkgs, inputs, perSystem, ... }:

let
  mkPythonApplication = file: args: pkgs.writeShellApplication ({
    text = "${pkgs.python3}/bin/python3 ${file} \"$@\"";
  } // args);
in {
  dev-shell = mkPythonApplication ./dev-shell.py {
    name = "dev-shell";
    runtimeInputs = [ perSystem.self.nix ];
  };

  fman = pkgs.writeShellApplication {
    name = "fman";
    runtimeInputs = with pkgs; [ fzf man ];
    text = builtins.readFile ./fman.sh;
  };

  mars-help = pkgs.writeShellApplication {
    name = "mars-help";
    runtimeInputs = [ perSystem.parcels.marswm ];
    text = builtins.readFile ./mars-help.sh;
  };

  mars-startup = pkgs.writeShellApplication {
    name = "mars-startup";
    runtimeInputs = with pkgs; [ perSystem.parcels.marswm touchegg xorg.xmodmap ];
    text = builtins.readFile ./mars-startup.sh;
  };

  mars-status = pkgs.writeShellApplication {
    name = "mars-status";
    runtimeInputs = with pkgs; [ gnugrep libcanberra-gtk3 libnotify power-profiles-daemon pulseaudio xkb-switch xmenu tinyxxd ];
    text = builtins.readFile ./mars-status.sh;
  };

  nix-maintenance = pkgs.writeShellApplication {
    name = "nix-maintenance";
    text = builtins.readFile ./nix-maintenance.sh;
  };

  open-document = pkgs.writeShellApplication {
    name = "open-document";
    runtimeInputs = with pkgs; [ file rofi gnugrep ];
    text = builtins.readFile ./open-document.sh;
  };

  replay-area = pkgs.writeShellApplication {
    name = "replay-area";
    runtimeInputs = with pkgs; [ ffmpeg-full slop ];
    text = builtins.readFile ./replay-area.sh;
  };

  riot = pkgs.writeShellApplication {
    name = "riot";
    runtimeInputs = with pkgs; [ bc perSystem.parcels.marswm slop xdo xmenu xorg.xwininfo ];
    text = builtins.readFile ./riot.sh;
  };

  rsc = pkgs.callPackage ./rsc { craneLib = inputs.parcels.inputs.crane.mkLib pkgs; };

  screencast = pkgs.writeShellApplication {
    name = "screencast";
    runtimeInputs = with pkgs; [ ffmpeg-full slop xorg.xrandr ];
    text = builtins.readFile ./screencast.sh;
  };

  search-nixpkgs = pkgs.writeShellApplication {
    name = "search-nixpkgs";
    runtimeInputs = with pkgs; [ fzf man jq ];
    text = builtins.readFile ./search-nixpkgs.sh;
  };

  set-wallpaper = pkgs.writeShellApplication {
    name = "set-wallpaper";
    runtimeInputs = with pkgs; [ xwallpaper ];
    text = builtins.readFile ./set-wallpaper.sh;
  };

  spotify-wm-compat = pkgs.writeShellApplication {
    name = "spotify-wm-compat";
    runtimeInputs = with pkgs; [ perSystem.parcels.marswm xdotool ];
    text = builtins.readFile ./spotify-wm-compat.sh;
  };

  sshfs-shell = pkgs.writeShellApplication {
    name = "sshfs-shell";
    runtimeInputs = with pkgs; [ sshfs ];
    text = builtins.readFile ./sshfs-shell.sh;
  };

  switch-dir = pkgs.writeShellApplication {
    name = "switch-dir";
    runtimeInputs = with pkgs; [ bat file fzf ];
    text = builtins.readFile ./switch-dir.sh;
  };

  wallpaper-daemon = pkgs.writeShellApplication {
    name = "wallpaper-daemon";
    runtimeInputs = with pkgs; [ gnugrep xorg.xev xwallpaper ];
    text = builtins.readFile ./wallpaper-daemon.sh;
  };

  xdg-xmenu = mkPythonApplication ./xdg-xmenu.py {
    name = "xdg-xmenu";
    runtimeInputs = [ pkgs.imagemagick ];
  };

  xrandr-daemon = pkgs.writeShellApplication {
    name = "xrandr-daemon";
    runtimeInputs = with pkgs; [ xorg.xrandr xorg.xev libnotify ];
    text = builtins.readFile ./xrandr-daemon.sh;
  };
}

