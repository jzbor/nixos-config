{ inputs, lib, config, pkgs, options, programs, ... }:

{
  nix = {
    # Activate nix flakes system wide
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";

    # Automatically run garbage collection for nix store
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 14d";
    # Automatically run optimiser for nix store
    optimise.automatic = true;
    # Maximum number of parallel threads in one build job
    settings.cores = 0; # 0 means all cores
    # Maximum number of jobs to run in parallel
    settings.max-jobs = "auto";
    # Build in sandboxed environment
    settings.sandbox = true;
  };

  # Make nixpkgs available to local nix commands like `nix shell` or `nix-shell`
  nix.nixPath = [ "nixpkgs=/etc/channels/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # Networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Define user accounts
  users.users = {
    jzbor = {
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "video" ];
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$8MXAsfQbb5EfFEENhATiC1$20plmLWRRjuGJZR2uxODYiTsZ6KKL6hrjaBnKs8c597";
    };
    guest = {
      extraGroups = [];
      isNormalUser = true;
      initialHashedPassword = "$y$j9T$Y5SWVProFs7edHT2KJzOs0$WbLvOevHGLXmZKA2UZCXGU8hi.u2A43QK8rffZiuL3.";
    };
  };

  # Available shells
  environment.shells = with pkgs; [
    bash
    dash
    zsh
  ];

  # Install some packages
  environment.systemPackages = with pkgs; [
    bash
    cryptsetup
    curl
    fd
    fzf
    home-manager
    neofetch
    nix-index
    ripgrep
    smartmontools
    wget
    zsh
  ];

  # Programs
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.less.enable = true;
  programs.traceroute.enable = true;
  programs.zsh.enable = true;

  # Default Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
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

  # Enable trim for ssds
  services.fstrim.enable = true;

  security.pam.mount = {
    enable = true;
    extraVolumes = [
      "<volume user=\"jzbor\" fstype=\"crypt\" path=\"/dev/disk/by-label/HOMECRYPT\" mountpoint=\"~\" options=\"crypto_name=crypt0,allow_discard,fstype=ext4\"/>"
      # extra drive on desktop-i5
      "<volume user=\"jzbor\" fstype=\"crypt\" path=\"/dev/disk/by-uuid/2fb1ab80-c89e-419a-96f3-ec89edbd4f16\" mountpoint=\"~/.bigdata\" options=\"crypto_name=crypt1,allow_discard,fstype=ext4\"/>"
    ];
    createMountPoints = true;

    # Kill remaining processes after final logout
    #logoutTerm = true;
    #logoutWait = 0;  # seconds
  };

  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ "jzbor" ];
    persist = true;
  }];

  # switch default skript shell to dash
  environment.binsh = "${pkgs.dash}/bin/dash";

  # Monitor hard drives
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.x11.enable = true;
    notifications.mail.enable = false;
  };

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
