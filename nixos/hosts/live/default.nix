{ pkgs, config, inputs, ... }:

{
  imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
        # "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
        ../../programs/nix.nix
  ];

  networking.hostName = "aarch64-live";
  environment.systemPackages = with pkgs; [
    btop
    htop
    lm_sensors
    neovim
    stress
    tmux
  ];
  #boot.kernelPackages = pkgs.linuxPackages_latest;
}
