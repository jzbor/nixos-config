{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "switch-dir";
  runtimeInputs = with pkgs; [ bat file fzf ];
  text = builtins.readFile ./switch-dir.sh;
}
