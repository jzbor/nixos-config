{ ... }:

{
  system.stateVersion = "24.05";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = false;
  };

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This is automatically enabled by nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen, but should not be needed
  services.throttled.enable = false;
}
