{ pkgs, config, ... }:

{
  imports = [
    ../../modules/boot/secure-boot.nix
  ];

  # Install some packages
  environment.systemPackages = with pkgs; [
    distrobox
  ];

  # Podman virtualisation for distrobox and development
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enabling secure boot
  #boot.bootspec.enable = true;
}
