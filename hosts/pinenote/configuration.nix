{ flake, inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-pinenote.nixosModules.default

    ../../modules/nixos/base/security.nix
    ../../modules/nixos/base/localization.nix
    ../../modules/nixos/base/memory.nix
    ../../modules/nixos/base/networking.nix

    ../../modules/nixos/programs/nix.nix
    ../../modules/nixos/programs/ssh.nix
    ../../modules/nixos/programs/firefox.nix

  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.05";
  networking.hostName = "pinenote";

  users.users.jzbor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    btop
    fd
    git
    htop
    neofetch
    neovim
    ripgrep
    squeekboard
    tealdeer
  ];
}
