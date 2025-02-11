{ pkgs, pname }: pkgs.symlinkJoin {
  name = pname;
  paths = with pkgs; [
    discord
    spotify
    signal-desktop
  ];
}
