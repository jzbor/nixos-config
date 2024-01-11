{ pkgs, inputs, ... }:

{
  imports = [
    ./networking.nix
    ./disks.nix
    ./users.nix
    ./localization.nix
    ./power-management.nix
    ./security.nix
    ./packages.nix

    inputs.nix-index-database.nixosModules.nix-index
  ];

  # Enable updates via fwupd
  services.fwupd.enable = true;

  # Enable the OpenSSH daemon and SSH Agent
  services.openssh.enable = true;

  # switch default system shell to dash
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

  # Generate man-page caches at build time
  documentation.man.generateCaches = true;

  # Logitech input devices
  hardware.logitech.wireless.enable = true;

  # Enable X Server and LightDM
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.enable = true;
  };

  # Enable GUI
  jzbor-system.de.marswm.enable = true;
  jzbor-system.de.xfce.enable = true;
}
