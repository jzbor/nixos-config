{ pkgs, inputs, ... }:

{
  imports = [ inputs.nix-sweep.nixosModules.default ];

  # Garbage collection
  services.nix-sweep = {
    enable = true;
    interval = "daily";
    removeOlder = "30d";
    keepMax = 30;
    keepMin = 5;
    gc = true;
    gcInterval = "weekly";
    gcQuota = 50;
    gcModest = true;
  };

  environment.etc."nix-sweep/presets.toml".source = pkgs.writers.writeTOML "presets.toml" {
    regular = {
      keep-min = 5;
      remove-older = "14d";
      keep-newer = "7d";
    };
  };
}
