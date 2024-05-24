{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "sshfs-shell";
  runtimeInputs = with pkgs; [ sshfs ];
  text = builtins.readFile ./sshfs-shell.sh;
}
