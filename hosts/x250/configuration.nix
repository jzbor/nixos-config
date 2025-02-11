{ flake, perSystem, ... }:

let
  pkgs = perSystem.nixpkgs;
  inherit (pkgs) lib;
in {
  imports = [ flake.nixosModules.default ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
  networking.hostName = "x250";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = true;
  };

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This is automatically enabled by nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen, but should not be needed
  services.throttled.enable = false;

  boot.initrd.luks.devices.crypt0-root.device = "/dev/disk/by-label/crypt0-root";

  fileSystems."/boot" = lib.mkForce {
    device = "/dev/disk/by-label/nixos-boot";
    fsType = "vfat";
  };

  hardware.graphics = { # hardware.graphics on unstable
    enable = true;
    extraPackages = with pkgs; [
      #intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; }; # Force intel-media-driver
}
