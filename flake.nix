{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    cf.url = "github:jzbor/cornflakes";

    parcels = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jzbor/nix-parcels";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    disko = {
      url = "github:nix-community/disko/v1.6.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote/v1.0.0";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/nix-index-database";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-pinenote.url = "github:jzbor/nixos-pinenote";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    marswm = {
      url = "github:jzbor/marswm";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cf.follows = "cf";
    };

    toro = {
      url = "github:jzbor/toro";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cf.follows = "cf";
    };

    nie = {
      url = "git+https://codeberg.org/jzbor/nie";
    };

    nix-sweep = {
      url = "github:jzbor/nix-sweep";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cf.follows = "cf";
    };
  };

  outputs = inputs: inputs.cf.lib.mkFlake {
    inherit inputs;

    perSystem = inputs.cf.lib.dirsToAttrsFn [
      ./packages
      ./legacyPackages
    ];

    outputs = { cfLib, inputs, ...}@args: {
      nixosConfigurations = cfLib.nixosFromDirs ./nixosConfigurations args;

      nixosModules = cfLib.dirToAttrs ./nixosModules;
      homeModules = cfLib.dirToAttrs ./homeModules;

      nixOnDroidConfigurations.default = {
        pkgs = import inputs.nixpkgs {
          overlays = [ inputs.parcels.overlays.default ];
          system = "aarch64-linux";
        };
        modules = [ ./nix-on-droid ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
  };
}
