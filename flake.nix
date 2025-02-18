{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    blueprint.url = "github:clo4/blueprint/generic-users";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    cf = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jzbor/cornflakes";
    };

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
      url = "github:nix-community/lanzaboote/v0.4.2";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/nix-index-database";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
  };

  outputs = inputs: (inputs.nixpkgs.lib.attrsets.recursiveUpdate
    (inputs.blueprint { inherit inputs; })
    (import ./misc inputs)
  );
}

