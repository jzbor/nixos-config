{ inputs, pkgs, ... }:

with pkgs.lib;
{
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
        # "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

        ../../nixosModules/programs/nix.nix
        ../../nixosModules/base/security.nix
        ../../nixosModules/base/networking.nix
        ../../nixosModules/base/localization.nix
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
  networking.networkmanager.plugins = mkForce [];

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
