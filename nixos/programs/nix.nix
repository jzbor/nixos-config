{ config, lib, pkgs, inputs, ... }:

{
  nix = {
    # Activate nix flakes system wide
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";

    # Automatically run garbage collection for nix store
    gc.automatic = true;
    gc.dates = "weekly";
    gc.randomizedDelaySec = "3h";
    gc.options = "--delete-older-than 30d";
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
  };

  # Make nixpkgs available to local nix commands like `nix shell` or `nix-shell`
  nix.nixPath = [ "nixpkgs=/etc/channels/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.my-overlay.to = { owner = "jzbor"; repo = "nix-overlay"; type = "github"; };
  nix.registry.homepage.to = { url = "ssh://git@github.com/jzbor/jzbor.github.io"; submodules = true; type = "git"; };
  nix.registry.cloud.to = { url = "ssh://git@github.com/jzbor/nixos-cloud"; type = "git"; };
}
