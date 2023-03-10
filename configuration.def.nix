{ config, pkgs, ... }:

{
  # Hostname
  networking.hostName = "HOSTNAME";

  # Import other configuration modules
  # (hardware-configuration.nix is autogenerated upon installation)
  # paths in nix expressions are always relative the file which defines them
  imports = IMPORT_OPTIONS;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "STATE_VERSION"; # Did you read the comment?
}
