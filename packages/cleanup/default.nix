{ pkgs, perSystem, pname }:

pkgs.writeShellApplication {
  name = pname;
  text = let
    action = "--interactive";
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

    ${perSystem.parcels.nix-sweep}/bin/nix-sweep ${action} --keep ${keep} --max ${max} --older ${older}
    echo
    if [ "$UID" != 0 ]; then
      echo "Please authenticate to remove system generations:"
      $SUDO ${perSystem.parcels.nix-sweep}/bin/nix-sweep ${action} --keep ${keep} --max ${max} --older ${older} --system
    else
      ${perSystem.parcels.nix-sweep}/bin/nix-sweep ${action} --keep ${keep} --max ${max} --older ${older} --system
    fi
    ${perSystem.parcels.nix-sweep}/bin/nix-sweep --gc
  '';
}
