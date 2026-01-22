{ self, inputs, pkgs, lib, ... }:

let
  report-battery = pkgs.stdenv.mkDerivation {
    name = "report-battery";
    src = ../t14;
    buildPhase = ''
      ${pkgs.rustc}/bin/rustc -C opt-level=s report-battery.rs
    '';
    installPhase = ''
      mkdir -pv $out/bin
      mv report-battery $out/bin/
    '';
  };
in {
  imports = [
    self.nixosModules.default
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "22.11";
  networking.hostName = "x1-carbon";

  jzbor-system.boot = {
    scheme = "traditional";
    secureBoot = true;
  };

  # Enable cross building for aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This is automatically enabled by nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen, but should not be needed
  services.throttled.enable = false;

  services.xserver.wacom.enable = true;

  jzbor-system.features.office.printing.vendors.hp = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "hplip"
  ];

  # Report battery usage to log
  systemd.services.report-battery-pre = {
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    description = "Record battery usage during suspend";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${report-battery}/bin/report-battery pre";
    };
  };
  systemd.services.report-battery-post = {
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    description = "Record battery usage during suspend";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${report-battery}/bin/report-battery post";
    };
  };
}
