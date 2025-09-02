{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-pinenote.nixosModules.default

    ../../nixosModules/base/security.nix
    ../../nixosModules/base/localization.nix
    ../../nixosModules/base/memory.nix
    ../../nixosModules/base/networking.nix

    ../../nixosModules/programs/nix.nix
    ../../nixosModules/programs/ssh.nix
    ../../nixosModules/programs/firefox.nix
  ];

  # TODO: remove
  users.users.pinenote = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "pinenote";
  };
  security.sudo = {
    enable = pkgs.lib.mkForce true;
    execWheelOnly = true;
  };


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

  services.openssh.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
}
