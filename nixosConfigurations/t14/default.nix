{ self, inputs, pkgs, ... }:

let
  inherit (pkgs) lib;
in {
  imports = [
    self.nixosModules.default
    # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-6th-gen
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
  networking.hostName = "t14";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = true;
  };

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.initrd.luks.devices.crypt0-root.device = "/dev/disk/by-label/crypt0-root";
  fileSystems."/boot" = lib.mkForce {
    device = "/dev/disk/by-label/nixos-boot";
    fsType = "vfat";
  };

  # Limit charging to 80%
  boot.initrd.availableKernelModules = [ "thinkpad_acpi" ];
  systemd.services."set-charging-limits" = {
    wantedBy = [ "multi-user.target" ];
    description = "Set charging limits";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellApplication {
      	name = "set-charging-limits";
	text = ''
	  echo 80 | ${pkgs.coreutils}/bin/tee /sys/class/power_supply/BAT?/charge_control_end_threshold
	  echo 60 | ${pkgs.coreutils}/bin/tee /sys/class/power_supply/BAT?/charge_control_start_threshold
	'';
      }}/bin/set-charging-limits";
    };
  };
}
