{pkgs, inputs, system, hostConfig ? null, ...}:

let
  offline = isNull hostConfig;
in pkgs.writeShellApplication {
  name = if builtins.isNull hostConfig then "install" else "install-${hostConfig}";
  text = ''
      REPLY=""

      die () { echo "$1"; exit 1; }
      usage () {
        echo "Usage: $0 <disk> <layout> ${if offline then "<profile>" else ""}"
        printf '\tdisks: %s\n' "$(lsblk -dprn -x name -o name,size | sed 's/\(.*\) \(.*\)/\1 (\2)/' | tr '\n' ' ')"
        printf '\tformats: %s\n' "$(find ${inputs.self}/disk-layouts -type f -exec basename '{}' .nix ';' | tr '\n' ' ')"
        exit 1
      }

      [ "$#" = ${if offline then "3" else "2"} ] || usage
      if [ "$UID" != 0 ]; then
        die "Must be run with root priviliges"
      fi

      #printf "\n=> Wiping disk header\n"
      #printf "This will wipe %s. Are you sure? [y/N] " "$1"
      #read -r
      #[ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ] || die "Aborted"
      #set -x
      #${pkgs.util-linux}/bin/wipefs -a "$1"
      #set +x

      printf "\n=> Formatting disk\n"
      #${inputs.self.packages.${system}.format}/bin/format "$1" "$2"
      ${inputs.disko.packages.${system}.default}/bin/disko --mode disko --argstr disk "$1" "${inputs.self}/disk-layouts/$2.nix"
      sleep 2

      printf "\n=> Mounting filesystems\n"
      set -x
      mount /dev/disk/by-label/nixos-root /mnt
      trap 'umount -R /mnt; trap - EXIT' EXIT INT HUP
      mkdir -p /mnt/boot
      mount /dev/disk/by-label/nixos-boot /mnt/boot
      set +x

      printf "\n=> Installing the system\n"
      set -x
      ${
        (if builtins.isNull hostConfig
        then "${pkgs.nixos-install-tools}/bin/nixos-install --impure --no-root-password --flake \"${inputs.self}#$3\""
        else "${pkgs.nixos-install-tools}/bin/nixos-install --impure --no-root-password --system \"${inputs.self.nixosConfigurations.${hostConfig}.config.system.build.toplevel}\"")
      }
      set +x

      printf "\n=> Changing use password\n"
      while true; do
        printf "Change password for: "
        read -r || break
        [ -z "$REPLY" ] && break
        nixos-enter -c "passwd $REPLY" && break
      done
      printf "\n=> Done\n"
  '';
}
