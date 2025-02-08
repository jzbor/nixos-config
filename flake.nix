{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    cf = {
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


  outputs = { self, nixpkgs, home-manager, cf, parcels, nixos-hardware, nix-colors, marswm, ... }@inputs: {

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

    # T400 LAPTOP
    nixosConfigurations.t400 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        { networking.hostName = "t400"; }
        ./nixos
        ./nixos/hosts/t400
      ];

      specialArgs = { inherit inputs; };
    };

    # X250 LAPTOP
    nixosConfigurations.x250 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        { networking.hostName = "x250"; }
        ./nixos
        ./nixos/hosts/x250
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

    # Rock5B UEFI Live USB
    nixosConfigurations.live-rock5b-dtb = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./nixos/hosts/live ./nixos/hosts/live/rock5b-dtb.nix ];
      specialArgs = { inherit inputs; };
    };

  } // {

    nixOnDroidConfigurations.default = let
      overlays = [ parcels.overlays.default ];
    in inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs {
        inherit overlays;
        system = "aarch64-linux";
      };
      modules = [ ./nix-on-droid ];
      extraSpecialArgs = { inherit inputs; };
    };

  } // {

    homeConfigurations.jzbor = home-manager.lib.homeManagerConfiguration (
      let
        system = "x86_64-linux";
        overlays = [
          parcels.overlays.default
          marswm.overlays.default
          inputs.nix-index-database.overlays.nix-index
        ];
        pkgs = import nixpkgs { inherit system; inherit overlays; };
      in {
        inherit pkgs;

        modules = [ ./home ];
        extraSpecialArgs = { inherit inputs; inherit nix-colors; inherit (inputs) nix-index-database;};
      });

    homeConfigurations."jzbor@pinebook-pro" = home-manager.lib.homeManagerConfiguration (
      let
        system = "aarch64-linux";
        overlays = [
          parcels.overlays.default
          marswm.overlays.default
          inputs.nix-index-database.overlays.nix-index
        ];
        pkgs = import nixpkgs { inherit system; inherit overlays; inherit inputs; };
      in {
        inherit pkgs;

        modules = [
          ./home

          {
            services.picom.enable = pkgs.lib.mkForce false;
            services.nextcloud-client.enable = pkgs.lib.mkForce false;
          }
        ];
        extraSpecialArgs = { inherit nix-colors; inherit (inputs) nix-index-database;};
      });
  } // (cf.mkLib nixpkgs).flakeForDefaultSystems (system:
  let
    pkgs = nixpkgs.legacyPackages."${system}";
    libcf = cf.mkLib nixpkgs;
    cacheName = "jzbor-de:desktop";
    inherit (pkgs) lib;
  in {
    ### PACKAGES ###
    packages = {
      live-iso-x86_64 = self.nixosConfigurations.live-x86_64.config.system.build.isoImage;
      live-iso-aarch64 = self.nixosConfigurations.live-aarch64.config.system.build.isoImage;
      live-iso-rock5b-dtb = self.nixosConfigurations.live-rock5b-dtb.config.system.build.isoImage;
      live-iso-rock5b-bsp = self.nixosConfigurations.live-rock5b-bsp.config.system.build.isoImage;

      install = pkgs.callPackage ./scripts/install.nix { inherit inputs; };
      format = pkgs.callPackage ./scripts/format.nix { inherit inputs; };

      proprietary-apps = pkgs.callPackage ./packages/proprietary-apps.nix {};
    } // (
      lib.concatMapAttrs (name: value: { "vm-${name}" = value.config.system.build.vm; }) self.nixosConfigurations
    );

    ### PACKAGES NOT COMPATIBLE WITH nix flake show ###
    legacyPackages = lib.mapAttrs' (name: host: {
      name = "live-offline_${name}";
      value = (nixpkgs.lib.nixosSystem {
        inherit (host.pkgs) system;
        modules = [
          ./nixos/hosts/live
          {
            environment.systemPackages = [self (pkgs.callPackage ./scripts/install.nix { inherit inputs; hostConfig = name; })];
            nix.settings.substituters = lib.mkForce [];
          }
        ];
        specialArgs = { inherit inputs; };
      }).config.system.build.isoImage;
    }) self.nixosConfigurations;

    ### APPS ###
    apps.default = self.apps.${system}.rebuild;

    apps.rebuild = libcf.createShellApp system {
      name = "rebuild";
      text = ''
      nix run ${self}#rebuild-system
      nix run ${self}#rebuild-home
      '';
    };

    apps.rebuild-system = libcf.createShellApp system {
      name = "rebuild";
      text = ''
        printf "\n=> Rebuilding system\n"

        if [ "$UID" = 0 ]; then
        SUDO=""
        elif command -v doas >/dev/null; then
        SUDO="doas"
        elif command -v sudo >/dev/null; then
        SUDO="sudo"
        fi

        set -x
        $SUDO ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "${self}" "$@"
        set +x

        if ${pkgs.attic-client}/bin/attic cache info ${cacheName} 2>/dev/null; then
          printf "\n=> Pushing system closure to binary cache (${cacheName})\n"
          temp="$(mktemp -d)"
          set -x
          cd "$temp"
          ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake "${self}" "$@"
          ${pkgs.attic-client}/bin/attic push ${cacheName} ./result || true
          rm -f ./result
            cd - >/dev/null
          rmdir "$temp"
        fi
      '';
    };

    apps.rebuild-home = libcf.createShellApp system {
      name = "rebuild-home";
      text = ''
        printf "\n=> Rebuilding home\n"

        if [ "$UID" != 0 ]; then
          set -x
          ${home-manager.packages.${system}.default}/bin/home-manager switch --flake "${self}" "$@"
          set +x

          if ${pkgs.attic-client}/bin/attic cache info ${cacheName} 2>/dev/null; then
            printf "\n=> Pushing home closure to binary cache (${cacheName})\n"
            temp="$(mktemp -d)"
            set -x
            cd "$temp"
            ${home-manager.packages.${system}.default}/bin/home-manager build --flake "${self}" "$@"
            ${pkgs.attic-client}/bin/attic push ${cacheName} ./result || true
            rm -f ./result
            cd - >/dev/null
            rmdir "$temp"
          fi
        else
          echo "Nothing to be done for user '$USER'"
        fi
      '';
    };

    apps.cleanup = let
      expireAfterDays = "14";
    in
    libcf.createShellApp system {
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

      if command -v nix-collect-garbage >/dev/null; then
        $SUDO "$(which nix-collect-garbage)" -d --delete-older-than "${expireAfterDays}d"
      else
        nix store gc
      fi
      '';
    };

    apps.full-maintenance = libcf.createShellApp system {
      name = "full-maintenance";
      text = ''
      printf "\n=> Updating system\n"
      nix run ${self}#rebuild-system
      printf "\n=> Updating home\n"
      nix run ${self}#rebuild-home
      printf "\n=> Cleaning up afterwards\n"
      nix run ${self}#cleanup
      '';
    };

    apps.run-vm = libcf.createShellApp system {
      name = "run-vm";
      text = ''
      path="$(nix build "${self}#nixosConfigurations.$1.config.system.build.vm" --no-link --print-out-paths)"
      "$path/bin/run-$1-vm"
      '';
    };

    apps.push-nvim = libcf.createShellApp system {
      name = "push-nvim";
      text = ''
        if [ "$#" != 1 ]; then
          echo "Usage: $(basename "$0") <ssh-host>" > /dev/stderr
          exit 1
        fi

        scp -r ${self.homeConfigurations.jzbor.config.home-files}/.config/nvim "$1:.config/"
        ssh "$1" "chmod -R u+rw ~/.config/nvim; tree ~/.config/nvim"
      '';
    };
  });
}
