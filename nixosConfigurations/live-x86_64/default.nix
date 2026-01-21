{ inputs, pkgs, self, ... }:

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
    disko
    htop
    hwloc
    lm_sensors
    nix-tree
    powertop
    stress
    tmux
  ];

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

  # Add flake to image
  environment.etc.nixos-config.source = self;
}
