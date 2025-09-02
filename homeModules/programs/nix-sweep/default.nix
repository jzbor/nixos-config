{ inputs, ... }:

{
  imports = [ inputs.nix-sweep.homeModules.default ];

  # Garbage collection
  services.nix-sweep = {
    enable = true;
    interval = "daily";
    removeOlder = "30d";
    keepMax = 30;
    keepMin = 5;
  };
}
