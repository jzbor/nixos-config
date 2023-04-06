{ inputs, lib, config, pkgs, options, programs, ... }:

{
  imports = [
    ./security.nix
    ./localization.nix
    ./packages.nix
    ./disks.nix

    ../programs/nix.nix
  ];

  # Networking
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  # Define user accounts
  users.users = {
    jzbor = {
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "video" "scanner" ];
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$8MXAsfQbb5EfFEENhATiC1$20plmLWRRjuGJZR2uxODYiTsZ6KKL6hrjaBnKs8c597";
    };
    guest = {
      extraGroups = [];
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$Y5SWVProFs7edHT2KJzOs0$WbLvOevHGLXmZKA2UZCXGU8hi.u2A43QK8rffZiuL3.";
    };
  };

  # Enable updates via fwupd
  services.fwupd.enable = true;

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # switch default skript shell to dash
  environment.binsh = "${pkgs.dash}/bin/dash";

  # Enable zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Logitech input devices
  hardware.logitech.wireless.enable = true;
}