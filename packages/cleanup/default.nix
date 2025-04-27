{ pkgs, perSystem, pname }:

pkgs.writeShellApplication {
  name = pname;
  text = let
    keep = toString 8;
    max = toString 32;
    older = toString 14;
  in ''
    if [ "$UID" = 0 ]; then
      SUDO=""
    elif command -v doas >/dev/null; then
      SUDO="doas"
    elif command -v sudo >/dev/null; then
      SUDO="sudo"
    fi

    ${perSystem.parcels.nix-sweep}/bin/nix-sweep cleanout --interactive --keep-min ${keep} --keep-max ${max} --remove-older ${older} home user
    echo
    if [ "$UID" != 0 ]; then
      echo "Please authenticate to remove system generations:"
      $SUDO ${perSystem.parcels.nix-sweep}/bin/nix-sweep cleanout --interactive --keep-min ${keep} --keep-max ${max} --remove-older ${older} system
    else
      ${perSystem.parcels.nix-sweep}/bin/nix-sweep cleanout --interactive --keep-min ${keep} --keep-max ${max} --remove-older ${older} system
    fi

    if [ "$#" = 1 ] && [ "$1" = "--gc" ]; then
      ${perSystem.parcels.nix-sweep}/bin/nix-sweep gc
    fi
  '';
}
