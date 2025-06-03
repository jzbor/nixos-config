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
    # package = pkgs.ollama-rocm;
    package = let
      pinPackage = { name, commit, sha256, }: (import (builtins.fetchTarball {
        inherit sha256;
        url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
      }) { system = pkgs.system; }).${name};
    in (pinPackage {
      name = "ollama";
      commit = "d0169965cf1ce1cd68e50a63eabff7c8b8959743";
      sha256 = "sha256:1hh0p0p42yqrm69kqlxwzx30m7i7xqw9m8f224i3bm6wsj4dxm05";
    });
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.1";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
}
