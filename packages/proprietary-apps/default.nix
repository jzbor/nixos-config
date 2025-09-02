{ pkgs, ... }: pkgs.symlinkJoin {
  name = "proprietary-apps";
  paths = with pkgs; [
    discord
    spotify
    signal-desktop
  ];
}
