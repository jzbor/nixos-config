{ flake, inputs, perSystem, ... }:

let
  pkgs = perSystem.nixpkgs;
  inherit (pkgs) lib;
in {
  imports = [
    flake.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "22.11";
  networking.hostName = "desktop-i5";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = true;
  };

  jzbor-system.features.gaming.enable = true;
  programs.adb.enable = true;

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # # Via/QMK support
  # environment.systemPackages = with pkgs; [ via ];
  # services.udev.packages = [ pkgs.via ];
  # Disable usb autosuspend, as it does not work with keyboard
  boot.kernelParams = [
    "usbcore.autosuspend=-1"
  ];

  environment.systemPackages = with pkgs; [
    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # winetricks (all versions)
    winetricks
  ];

  networking.firewall.enable = lib.mkForce false;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.1";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
}
