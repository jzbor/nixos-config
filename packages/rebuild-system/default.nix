{ flake, pkgs, pname }: pkgs.writeShellApplication {
  name = pname;
  text = let
    cacheName = "desktop";
  in ''
        printf "\n=> Rebuilding system\n"

        if [ "$UID" = 0 ]; then
        SUDO=""
        elif command -v doas >/dev/null; then
        SUDO="doas"
        elif command -v sudo >/dev/null; then
        SUDO="sudo"
        fi

        set -x
        $SUDO ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "${flake}" "$@"
        set +x

        if ${pkgs.attic-client}/bin/attic cache info ${cacheName} 2>/dev/null; then
          printf "\n=> Pushing system closure to binary cache (${cacheName})\n"
          temp="$(mktemp -d)"
          set -x
          cd "$temp"
          ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake "${flake}" "$@"
          ${pkgs.attic-client}/bin/attic push ${cacheName} ./result || true
          rm -f ./result
            cd - >/dev/null
          rmdir "$temp"
        fi
  '';
}
