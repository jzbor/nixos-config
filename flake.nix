{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    jzbor-overlay.inputs.nixpkgs.follows = "nixpkgs";
    jzbor-overlay.url = "github:jzbor/nix-overlay";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };


  outputs = { self, nixpkgs, jzbor-overlay, lanzaboote, nix-index-database, nixos-hardware }@inputs:
    let
      pkgs-x86_64 = (import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        }).extend jzbor-overlay.overlays.default;
      pkgs-aarch64 = (import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        }).extend jzbor-overlay.overlays.default;
    in {

      # X1-CARBON LAPTOP
      nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs-x86_64;

        modules = [
          { networking.hostName = "x1-carbon"; }
          {
          }
          ./nixos
          ./nixos/hosts/x1-carbon

          nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
        ];

        specialArgs = { inherit inputs; };
      };

      # E531 LAPTOP
      nixosConfigurations.e531 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs-x86_64;

        modules = [
          { networking.hostName = "e531"; }
          ./nixos
        ];

        specialArgs = { inherit inputs; };
      };

      # i5 DESKTOP
      nixosConfigurations.desktop-i5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs-x86_64;

        modules = [
          { networking.hostName = "desktop-i5"; }
          ./nixos

          ./nixos/hosts/desktop-i5

          nixos-hardware.nixosModules.common-cpu-intel-cpu-only
          nixos-hardware.nixosModules.common-gpu-amd
        ];

        specialArgs = { inherit inputs; };
      };

      # PINEBOOK PRO
      nixosConfigurations.pinebook-pro = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = pkgs-aarch64;

        modules = [
          { networking.hostName = "pinebook-pro"; }
          ./nixos

          ./nixos/hosts/pinebook-pro

          nixos-hardware.nixosModules.pine64-pinebook-pro
        ];

        specialArgs = { inherit inputs; };
      };
  };
}
