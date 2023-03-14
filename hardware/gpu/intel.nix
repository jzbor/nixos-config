# source: https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/intel/default.nix

{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "i915" ];

  hardware.opengl.enable = true;

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    libva-utils
    libvdpau-va-gl
    vaapiIntel
  ];

  environment.systemPackages = with pkgs; [
    libva-utils
    intel-gpu-tools
  ];
}
