{ pkgs, inputs, system, ... }:

with pkgs.lib;
let
  wallpaper = "${inputs.nixos-pinenote.packages.aarch64-linux.escher-wallpapers}/waterfall.png";
  update-lock-screen = let
    rotate = name: orig: pkgs.stdenv.mkDerivation {
      inherit name;
      src = orig;
      dontUnpack = true;
      dontInstall = true;
      buildPhase = ''
        ${pkgs.imagemagick}/bin/magick convert ${orig} -rotate -90 $out
      '';
    };
    lockImage = rotate "wallpaper.png" wallpaper;
  in pkgs.writeShellApplication {
    name = "update-lock-screen";
    text = "${pkgs.systemd}/bin/busctl --user call org.pinenote.PineNoteCtl /org/pinenote/PineNoteCtl org.pinenote.Ebc1 SetOffScreen s ${lockImage}";
  };

  switch-boot-partition = pkgs.writeShellApplication {
    name = "switch-boot-partition";
    runtimeInputs = with pkgs; [ parted ];
    text = readFile ./scripts/switch-boot-partition.sh;
  };

  pn-wmenu = pkgs.writeShellApplication {
    name = "pn-wmenu";
    text = ''
      set +e
      pkill -SIGUSR2 wvkbd-mobintl
      wmenu-run -N ffffff -n 000000 -M 000000 -m ffffff -S 000000 -s ffffff -f 'mono 12' -p run -l 10
      pkill -SIGUSR1 wvkbd-mobintl
    '';
  };

  pn-lock = pkgs.writeShellApplication {
    name = "pn-lock";
    text = ''
      pw="$(< ~/.config/peanutbutter_pw)"
      PEANUTBUTTER_PASSCODE="$pw" peanutbutter &
      wait
    '';
  };

  pn-lock-suspend = pkgs.writeShellApplication {
    name = "pn-lock-suspend";
    text = ''
      pw="$(< ~/.config/peanutbutter_pw)"
      PEANUTBUTTER_PASSCODE="$pw" peanutbutter &
      systemctl suspend
      wait
    '';
  };

  pnctl = pkgs.writeShellApplication {
    name = "pnctl";
    runtimeInputs = with pkgs; [ systemd ];
    text = ''
      action="$1"
      shift
      busctl "$action" --user org.pinenote.PineNoteCtl /org/pinenote/PineNoteCtl org.pinenote.Ebc1 "$@"
    '';
  };
in {
  imports = [
    ../../homeModules/programs

    ./sway.nix
    ./waybar.nix
    # ./toolkits.nix
  ];

  home.packages = with pkgs; [
    attic-client
    brightnessctl
    evince
    inputs.parcels.packages.${system}.peanutbutter
    nautilus
    nix-tree
    pn-lock
    pn-lock-suspend
    pn-wmenu
    pnctl
    switch-boot-partition
    tree
    update-lock-screen
    xmenu
    xournalpp
    zathura
    zoxide
  ];

  home.stateVersion = "25.11";
  home.username = "jzbor";
  home.homeDirectory = "/home/jzbor";

  home.file.".config/menu".source = ./menu;

  jzbor-home.programs.vis.enable = true;
  jzbor-home.programs.nix-sweep.enable = true;
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.zsh.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  programs.bash.enable = true;
  programs.zoxide.enableBashIntegration = true;

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  services.gnome-keyring.enable = true;

  services.mako = {
    enable = true;
    settings = {
      background-color = "#FFFFFF";
      text-color = "#000000";
      border-color = "#000000";
      on-touch = "invoke-default-action";
      font = "Comic Mono 12";
      default-timeout = 5000;
    };
  };
}
