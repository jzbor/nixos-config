{ config, pkgs, options, ... }:

{
  nixpkgs.overlays = [ (import ./packages) ];
  nixpkgs.config.allowUnfree = true;

  nix = {
    # Automatically run garbage collection for nix store
    gc.automatic = true;
    gc.dates = " daily";
    gc.options = "--delete-older-than 30d";
    # Automatically run optimiser for nix store
    optimise.automatic = true;
    # Maximum number of parallel threads in one build job
    settings.cores = 0; # 0 means all cores
    # Maximum number of jobs to run in parallel
    settings.max-jobs = "auto";
    # Build in sandboxed environment
    settings.sandbox = true;

    # Custom package overlay
    nixPath = options.nix.nixPath.default ++ [
      "nixpkgs-overlays=/etc/nixos/packages"
    ];
  };

  # Networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Define user accounts
  users.users =
    {
      jzbor =
        {
          extraGroups = [ "wheel" "networkmanager" ];
          isNormalUser = true;
          initialHashedPassword = "$y$j9T$8MXAsfQbb5EfFEENhATiC1$20plmLWRRjuGJZR2uxODYiTsZ6KKL6hrjaBnKs8c597";
        };
      guest =
        {
          extraGroups = [];
          isNormalUser = true;
          initialHashedPassword = "$y$j9T$Y5SWVProFs7edHT2KJzOs0$WbLvOevHGLXmZKA2UZCXGU8hi.u2A43QK8rffZiuL3.";
        };
      };

  # Install some packages
  environment.systemPackages =
    with pkgs;
    [
      cryptsetup
      curl
      fd
      git
      htop
      neofetch
      ripgrep
      wget
      zsh
    ];

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  # Documentation
  documentation.man.enable = true;

  # Fonts
  fonts.enableDefaultFonts = true;

  # Display manager
  services.xserver.displayManager.lightdm.greeters.gtk = {
    enable = true;
    theme = {
      name = "Orchis-Yellow-Dark-Compact";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };
  };

  security.pam.mount = {
    enable = true;
    extraVolumes = [
      "<volume user=\"jzbor\" fstype=\"crypt\" path=\"/dev/disk/by-label/HOMECRYPT\" mountpoint=\"~\" options=\"crypto_name=crypt0,allow_discard,fstype=ext4\"/>"
    ];
    createMountPoints = true;

    # Kill remaining processes after final logout
    logoutTerm = true;
    logoutWait = 0;  # seconds
  };
}
