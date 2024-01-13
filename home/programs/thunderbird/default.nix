{ pkgs, lib, config, ... }:

{
  # Add thunderbird to environment
  programs.thunderbird.enable = true;

  programs.thunderbird.profiles.default = {
    isDefault = true;
    settings = {};
  };
}
