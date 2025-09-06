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

    ./plymouth.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "25.05";
  networking.hostName = "pinenote";

  boot.initrd.systemd.enable = true;

  users.users.jzbor = {
    shell = pkgs.bash;
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
    tealdeer
  ];

  services.openssh.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  jzbor-pinenote.graphical.autologinUser = "jzbor";

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    LidSwitch = "ignore";
  };
}
