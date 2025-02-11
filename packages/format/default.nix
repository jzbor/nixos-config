{pkgs, inputs, system, ...}: pkgs.writeShellApplication {
  name = "format";
  text = ''
      die () { echo "$1"; exit 1; }
      usage () { echo "Usage: $0 <disk> <layout>"; exit 1; }
      [ "$#" = 2 ] || usage
      echo ${inputs.disko.packages.${system}.default}/bin/disko --arg disk "$1" "${inputs.self}/disk-layouts/$2.nix"
      ${inputs.disko.packages.${system}.default}/bin/disko --mode format --argstr disk "$1" "${inputs.self}/disk-layouts/$2.nix"
  '';
}
