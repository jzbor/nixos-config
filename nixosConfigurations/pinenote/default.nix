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
    extraGroups = [ "wheel" "networkmanager" "input" ];
  };

  environment.systemPackages = with pkgs; [
    btop
    fd
    git
    htop
    fastfetch
    neovim
    ripgrep
    tealdeer
    tmux
  ];
  programs.firefox.enable = true;

  services.openssh.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  jzbor-pinenote.graphical.autologinUser = "jzbor";

  # Disable speechd (enabled by default on graphic systems)
  services.speechd.enable = pkgs.lib.mkForce false;

  security.pam.services.login.enableGnomeKeyring = true;

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    LidSwitch = "ignore";
  };

  # Disable wake on lid switch
  systemd.services."disable-wake-on-lid-switch" = {
    wantedBy = [ "multi-user.target" ];
    description = "Disable wake on lid switch";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellApplication {
      	name = "disable-wake-on-lid-switch";
	text = ''
	  echo disabled | ${pkgs.coreutils}/bin/tee /sys/devices/platform/gpio-keys/power/wakeup
	'';
      }}/bin/disable-wake-on-lid-switch";
    };
  };

  systemd.user.services.pinenote-service-sway.serviceConfig.ExecStartPre = "env";
}
