{ config, pkgs, ... }:

{
  sound.enable = true;

  # Pulseaudio (disabled)
  hardware.pulseaudio.enable = false;

  # Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
}
