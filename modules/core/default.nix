{ inputs, lib, config, pkgs, options, programs, ... }:

{
  imports = [
    ./security.nix
    ./localization.nix
    ./packages.nix
    ./disks.nix

    ../programs/nix.nix

    inputs.nix-index-database.nixosModules.nix-index
  ];

  # Networking
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  # networking.networkmanager.dhcp = "dhcpcd";

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

  # Enable the OpenSSH daemon and SSH Agent
  services.openssh.enable = true;
  programs.ssh.agentTimeout = "1h";
  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = "AddKeysToAgent yes";

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

  # Use nix-locate as command not found replacement
  # It seems to handle flakes and stuff better
  programs.command-not-found.enable = false;
  programs.bash.interactiveShellInit = ''
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  '';
  programs.zsh.interactiveShellInit = ''
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  '';
}
