{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "open-document";
  runtimeInputs = with pkgs; [ file rofi gnugrep ];
  text = builtins.readFile ./open-document.sh;
}
