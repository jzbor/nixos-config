{ pkgs, ... }: pkgs.symlinkJoin {
  name = "proprietary-apps";
  paths = with pkgs; [
    spotify
    discord
    signal-desktop
  ];
}
