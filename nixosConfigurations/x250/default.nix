{ self, pkgs, ... }:

let
  inherit (pkgs) lib;
in {
  imports = [ self.nixosModules.default ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
  networking.hostName = "x250";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = true;
  };
  boot.lanzaboote.pkiBundle = lib.mkForce "/var/lib/sbctl";

  boot.initrd.availableKernelModules = [ "thinkpad_acpi" ];

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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


  # Enable Cinnamon desktop env
  jzbor-system.de.cinnamon.enable = true;

  jzbor-system.features.office.printing.vendors.hp = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "hplip"
  ];

}
