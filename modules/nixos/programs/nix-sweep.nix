{ pkgs, inputs, perSystem, ... }:

{
  imports = [ inputs.nix-sweep.nixosModules.default ];

  # Garbage collection
  services.nix-sweep = {
    enable = true;
    # package = perSystem.parcels.nix-sweep;
    interval = "daily";
    removeOlder = "30d";
    keepMax = 30;
    keepMin = 5;
    gc = true;
    gcInterval = "weekly";
  };

  environment.etc."nix-sweep/presets.toml".source = pkgs.writers.writeTOML "presets.toml" {
    regular = {
      keep-min = 5;
      remove-older = "14d";
      keep-newer = "7d";
    };
  };
}
