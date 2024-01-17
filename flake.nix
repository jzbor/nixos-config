{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    cf.url = "github:jzbor/cornflakes";
    cf.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    jzbor-overlay.inputs.nixpkgs.follows = "nixpkgs";
    jzbor-overlay.url = "github:jzbor/nix-overlay";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };


  outputs = { self, nixpkgs, home-manager, cf, jzbor-overlay, nixos-hardware, nix-colors, ... }@inputs: {

    # X1-CARBON LAPTOP
    nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        { networking.hostName = "x1-carbon"; }
        ./nixos
        ./nixos/hosts/x1-carbon
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
      ];

      specialArgs = { inherit inputs; };
    };

    # E531 LAPTOP
    nixosConfigurations.e531 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        { networking.hostName = "e531"; }
        { jzbor-system.boot.scheme = "traditional"; }
        ./nixos
      ];

      specialArgs = { inherit inputs; };
    };

    # i5 DESKTOP
    nixosConfigurations.desktop-i5 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # pkgs = getPkgs "x86_64-linux";

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

      modules = [
        { networking.hostName = "pinebook-pro"; }
        ./nixos

        ./nixos/hosts/pinebook-pro

        nixos-hardware.nixosModules.pine64-pinebook-pro
      ];

      specialArgs = { inherit inputs; };
    };

    # aarch64 UEFI Live USB
    nixosConfigurations.live-aarch64 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./nixos/hosts/live ];
      specialArgs = { inherit inputs; };
    };

    # x86_64 UEFI Live USB
    nixosConfigurations.live-x86_64 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./nixos/hosts/live ];
      specialArgs = { inherit inputs; };
    };


  } // {

    homeConfigurations.jzbor = home-manager.lib.homeManagerConfiguration (
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system}.extend jzbor-overlay.overlays.default;
      in {
        inherit pkgs;

        modules = [ ./home ];
        extraSpecialArgs = { inherit nix-colors; };
      });

    homeConfigurations."jzbor@pinebook-pro" = home-manager.lib.homeManagerConfiguration (
      let
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system}.extend jzbor-overlay.overlays.default;
      in {
        inherit pkgs;

        modules = [
          ./home

          {
            services.picom.enable = pkgs.lib.mkForce false;
            services.nextcloud-client.enable = pkgs.lib.mkForce false;
          }
        ];
        extraSpecialArgs = { inherit nix-colors; };
      });
  } // cf.lib.flakeForDefaultSystems (system:
  let
    pkgs = nixpkgs.legacyPackages."${system}";
    lib = pkgs.lib;
  in {
    ### PACKAGES ###
    packages = {
      live-iso-x86_64 = self.nixosConfigurations.live-x86_64.config.system.build.isoImage;
      live-iso-aarch64 = self.nixosConfigurations.live-aarch64.config.system.build.isoImage;
    } // (
      lib.concatMapAttrs (name: value: { "vm-${name}" = value.config.system.build.vm; }) self.nixosConfigurations
    );


    ### APPS ###
    apps.rebuild = cf.lib.createShellApp system {
      name = "rebuild";
      text = ''
      if [ "$UID" = 0 ]; then
        SUDO=""
      elif command -v doas >/dev/null; then
        SUDO="doas"
      elif command -v sudo >/dev/null; then
        SUDO="sudo"
      fi

      set -x
      $SUDO nixos-rebuild switch --flake "${self}" "$@"
      '';
    };

    apps.rebuild-home = cf.lib.createShellApp system {
      name = "rebuild-home";
      text = ''
      if [ "$UID" != 0 ]; then
        set -x
        ${home-manager.packages.${system}.default}/bin/home-manager switch --flake "${self}" "$@"
      else
        echo "Nothing to be done for user '$USER'"
      fi
      '';
    };

    apps.cleanup = let
      expireAfterDays = "30";
    in
    cf.lib.createShellApp system {
      name = "cleanup";
      text = ''
      if [ "$UID" = 0 ]; then
        SUDO=""
      elif command -v doas >/dev/null; then
        SUDO="doas"
      elif command -v sudo >/dev/null; then
        SUDO="sudo"
      fi

      if [ "$UID" != 0 ]; then
        set -x
        ${home-manager.packages.${system}.default}/bin/home-manager expire-generations "-${expireAfterDays} days"
        nix profile wipe-history --older-than "${expireAfterDays}d";
      else
        set -x
      fi
      $SUDO nix-collect-garbage -d --delete-older-than "${expireAfterDays}d"
      nix store optimise
      '';
    };

    apps.full-maintenance = cf.lib.createShellApp system {
      name = "full-maintenance";
      text = ''
      printf "\n=> Updating system\n"
      nix run ${self}#rebuild
      printf "\n=> Updating home\n"
      nix run ${self}#rebuild-home
      printf "\n=> Cleaning up afterwards\n"
      nix run ${self}#cleanup
      '';
    };

    apps.run-vm = cf.lib.createShellApp system {
      name = "run-vm";
      text = ''
        path="$(nix build "${self}#nixosConfigurations.$1.config.system.build.vm" --no-link --print-out-paths)"
        "$path/bin/run-$1-vm"
      '';
    };

  });
}
