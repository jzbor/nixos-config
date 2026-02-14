{ config, inputs, pkgs, ... }:

{
  nix = {
    package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nix;

    # Automatically run optimiser for nix store
    optimise.automatic = true;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@wheel" ];

      # Garbage Collection
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      min-free = toString (4 * 1042 * 1024 * 1024);
      max-free = toString (16 * 1042 * 1024 * 1024);

      # Building
      cores = 0; # 0 means all cores
      max-jobs = "auto";
      sandbox = true;

      # Substitution
      max-substitution-jobs = 128;
      http-connections = 128;
      connect-timeout = 10;
      fallback = true;

      # Binary caches
      netrc-file = "/etc/nix/netrc";
      substituters = [
        "https://cache.nixos.org?priority=1"
        "https://cache.jzbor.de/desktop?priority=2"
        "https://cache.jzbor.de/public?priority=3"
        "https://nix-community.cachix.org?priority=4"
        "https://cache.jzbor.de/sp?priority=5"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "desktop:feMjIkyrgSZI+5lrUnKe3iwgGoykffN4ihScaBC/J7w="
        "sp:v8udot3ROy99u4GTQZ79zsRxpzNLvYrTSN17odOHMnc="
        "public:AdkE6qSLmWKFX4AptLFl+n+RTPIo1lrBhT2sPgfg5s4="
      ];

      # Disable online registry
      flake-registry = "";
    };

  };

  # Make nixpkgs available to local nix commands like `nix shell` or `nix-shell`
  nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
  environment.etc.nixpkgs.source = "${inputs.nixpkgs}";
  environment.etc.nixos-config.source = "${inputs.self}";

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    parcels.to = { owner = "jzbor"; repo = "nix-parcels"; type = "github"; };
    cornflakes.to = { owner = "jzbor"; repo = "cornflakes"; type = "github"; };
    templates.to = config.nix.registry.cornflakes.to;
    homepage.to = { url = "ssh://git@github.com/jzbor/jzbor.github.io"; submodules = true; type = "git"; };
    cloud.to = { url = "ssh://git@github.com/jzbor/nixos-cloud"; type = "git"; };
    sp.to = { url = "ssh://git@gitlab.cs.fau.de/i4/sp/uebung"; type = "git"; submodules =true; };
    sp-jzbor.to = { url = "ssh://git@gitlab.cs.fau.de/i4/sp/uebung"; ref = "jzbor-nix"; type = "git"; submodules = true; };
    nixos-config.to = { owner = "jzbor"; repo = "nixos-config"; type = "github"; };
    zinn.to = { owner = "jzbor"; repo = "zinn"; type = "github"; };
  };

  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
}
