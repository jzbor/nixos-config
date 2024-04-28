{ pkgs, ... }:

{
  system.stateVersion = "22.11";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = true;
  };

  # Install some packages
  environment.systemPackages = with pkgs; [
    distrobox
    podman-compose
  ];

  # Podman virtualisation for distrobox and development
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This is automatically enabled by nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen, but should not be needed
  services.throttled.enable = false;
}
