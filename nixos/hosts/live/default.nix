{ pkgs, inputs, ... }:

{
  imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
        # "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
        ../../programs/nix.nix
  ];

  networking.hostName = "nixos-live";
  environment.systemPackages = with pkgs; [
    btop
    htop
    lm_sensors
    stress
    tmux
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 9";
}
