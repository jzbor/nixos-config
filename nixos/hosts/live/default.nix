{ pkgs, inputs, lib, ... }:

{
  imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
        # "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

        ../../programs/nix.nix
        ../../base/security.nix
        ../../base/networking.nix
        ../../base/localization.nix
  ];

  networking.hostName = "nixos-live";
  environment.systemPackages = with pkgs; [
    btop
    htop
    lm_sensors
    stress
    tmux
    nix-tree
  ];

  networking.wireless.enable = false;  # wpa_supplicant conflicts with NetworkManager
  networking.networkmanager.plugins = lib.mkForce [];

  # Enable zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  isoImage.squashfsCompression = "gzip -Xcompression-level 9";

  # Disable global registry for offline support
    nix.settings.flake-registry = "";
}
