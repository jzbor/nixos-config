{ pkgs, inputs, ... }:

with pkgs.lib;
let
  wallpaper = "${inputs.nixos-pinenote.packages.aarch64-linux.escher-wallpapers}/waterfall.png";
  rotate = name: orig: pkgs.stdenv.mkDerivation {
    inherit name;
    src = orig;
    dontUnpack = true;
    dontInstall = true;
    buildPhase = ''
      ${pkgs.imagemagick}/bin/magick convert ${orig} -rotate -90 $out
    '';
  };
  lockImage = rotate "waterfall-180.png" wallpaper;
  update-lock-screen = pkgs.writeShellApplication {
    name = "update-lock-screen";
    text = "${pkgs.systemd}/bin/busctl --user call org.pinenote.PineNoteCtl /org/pinenote/PineNoteCtl org.pinenote.Ebc1 SetOffScreen s ${lockImage}";
  };
in {
  imports = [
    ../../homeModules/programs

    ./sway.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    nix-tree
    xmenu
    zoxide
    update-lock-screen
  ];

  home.stateVersion = "25.11";
  home.username = "jzbor";
  home.homeDirectory = "/home/jzbor";

  jzbor-home.programs.vis.enable = true;
  jzbor-home.programs.nix-sweep.enable = true;
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.zsh.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  programs.zoxide.enableBashIntegration = true;

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
