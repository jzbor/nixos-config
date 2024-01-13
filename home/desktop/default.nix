{ pkgs, ... }:

{
  imports = [
    ../programs/fontconfig

    ../programs/firefox
    ../programs/captive-browser
    ../programs/thunderbird
    ../programs/mpv

    ../theming
  ];
}

