{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    jzbor-overlay.url = "github:jzbor/nix-overlay";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };


  outputs = { self, nixpkgs, jzbor-overlay, nixos-hardware }@inputs:
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
          ./hosts/laptop

          nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
          { services.throttled.enable = false; }
        ];

        specialArgs = { inherit inputs; };
      };

      # i5 DESKTOP
      nixosConfigurations.desktop-i5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs-x86_64;

        modules = [
          { networking.hostName = "desktop-i5"; }
          ./hosts/desktop
          ./modules/collections/gaming.nix

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
          ./hosts/laptop

          nixos-hardware.nixosModules.pine64.pinebook-pro
        ];

        specialArgs = { inherit inputs; };
      };
  };
}
