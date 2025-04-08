{ pkgs, config, inputs, perSystem, ... }:

{
  imports = [ inputs.nix-sweep.nixosModules.default ];
  nix = {
    # Activate nix flakes system wide
    package = pkgs.nix;
    extraOptions = ''
      min-free = ${toString (16 * 1042 * 1024 * 1024)}
      max-free = ${toString (32 * 1042 * 1024 * 1024)}
      http-connections = 128
      experimental-features = nix-command flakes
      netrc-file = /etc/nix/netrc
    '';

    # Keep generated outputs on garbage collection
    settings.keep-outputs = true;
    settings.keep-derivations = true;
    # Auto optimise store on builds
    settings.auto-optimise-store = true;
    # Automatically run optimiser for nix store
    optimise.automatic = true;
    # Maximum number of parallel threads in one build job
    settings.cores = 0; # 0 means all cores
    # Maximum number of jobs to run in parallel
    settings.max-jobs = "auto";
    # Build in sandboxed environment
    settings.sandbox = true;
    settings.max-substitution-jobs = 128;

    # Binary caches
    settings.substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://cache.jzbor.de/desktop"
      "https://cache.jzbor.de/sp"
      "https://cache.jzbor.de/public"
    ];
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "desktop:feMjIkyrgSZI+5lrUnKe3iwgGoykffN4ihScaBC/J7w="
      "sp:v8udot3ROy99u4GTQZ79zsRxpzNLvYrTSN17odOHMnc="
      "public:AdkE6qSLmWKFX4AptLFl+n+RTPIo1lrBhT2sPgfg5s4="
    ];

    # Disable online registry
    settings.flake-registry = "";
  };

  # Garbage collection
  services.nix-sweep = {
    enable = true;
    # package = perSystem.parcels.nix-sweep;
    interval = "daily";
    older = 30;
    max = 30;
    gc = true;
    gcInterval = "weekly";
  };

  # Make nixpkgs available to local nix commands like `nix shell` or `nix-shell`
  nix.nixPath = [ "nixpkgs=/etc/channels/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    parcels.to = { owner = "jzbor"; repo = "nix-parcels"; type = "github"; };
    cornflakes.to = { owner = "jzbor"; repo = "cornflakes"; type = "github"; };
    templates.to = config.nix.registry.cornflakes.to;
    homepage.to = { url = "ssh://git@github.com/jzbor/jzbor.github.io"; submodules = true; type = "git"; };
    cloud.to = { url = "ssh://git@github.com/jzbor/nixos-cloud"; type = "git"; };
    sp.to = { url = "ssh://git@gitlab.cs.fau.de/wa94tiju/sp-flake"; type = "git"; };
    nixos-config.to = { owner = "jzbor"; repo = "nixos-config"; type = "github"; };
    zinn.to = { owner = "jzbor"; repo = "zinn"; type = "github"; };
  };
}
