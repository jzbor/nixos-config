{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "search-nixpkgs";
  runtimeInputs = with pkgs; [ fzf man jq ];
  text = builtins.readFile ./search-nixpkgs.sh;
}
