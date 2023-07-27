{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    jzbor-overlay.url = "github:jzbor/nix-overlay";
    jzbor-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { self, nixpkgs, jzbor-overlay, nixos-hardware, lanzaboote }@inputs:
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
          ./hosts/x1-carbon
          ./modules/boot/boot-verbose.nix

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
          ./modules/boot/boot-verbose.nix

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
          ./hosts/common
          ./modules/boot/boot-pbp.nix
          ./modules/desktop/xfce.nix
          ./modules/desktop/marswm.nix

          {
            swapDevices = [ {
              device = "/var/lib/swapfile";
              size = 8*1024;  # in megabytes
            }];
          }

          nixos-hardware.nixosModules.pine64-pinebook-pro
        ];

        specialArgs = { inherit inputs; };
      };

      # HETZNER HOST FSN1-02
      nixosConfigurations.fsn1-02 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = pkgs-aarch64;

        modules = [
          { networking.hostName = "fsn1-02"; }
          ./hosts/server
          #./modules/boot/boot-verbose.nix
          { boot.loader.grub.devices = [ "/dev/sda" ]; }

          {
            systemd.network.networks."10-wan".address = [
              # replace this address with the one assigned to your instance
              "2a01:4f8:aaaa:bbbb::1/64"
            ];
          }
        ];

        specialArgs = { inherit inputs; };
      };
  };
}
