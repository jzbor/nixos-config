{ pkgs, inputs, ... }:

{
  environment.packages = with pkgs; [
    bashInteractive
    btop
    cacert
    coreutils
    curl
    fd
    git
    htop
    ripgrep
    tmux
    vim
  ];
  system.stateVersion = "24.05";

  terminal.colors = {
    background = "#FFFFFF";
    foreground = "#000000";
    cursor = "#000000";
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    substituters = [
      "https://cache.nixos.org"
      "https://nix-on-droid.cachix.org"
    ];
    trustedPublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
    ];

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      parcels.to = { owner = "jzbor"; repo = "nix-parcels"; type = "github"; };
      cornflakes.to = { owner = "jzbor"; repo = "cornflakes"; type = "github"; };
      templates.to = { owner = "jzbor"; repo = "cornflakes"; type = "github"; };
      homepage.to = { url = "ssh://git@github.com/jzbor/jzbor.github.io"; submodules = true; type = "git"; };
      cloud.to = { url = "ssh://git@github.com/jzbor/nixos-cloud"; type = "git"; };
      sp.to = { url = "ssh://git@gitlab.cs.fau.de/wa94tiju/sp-flake"; type = "git"; };
      nixos-config.to = { owner = "jzbor"; repo = "nixos-config"; type = "github"; };
      zinn.to = { owner = "jzbor"; repo = "zinn"; type = "github"; };
    };
  };
}
