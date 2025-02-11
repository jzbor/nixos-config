{ pkgs, perSystem, pname, flake }: pkgs.writeShellApplication {
  name = pname;
  text = let
    cacheName = "desktop";
  in ''
    printf "\n=> Rebuilding home\n"

    if [ "$UID" != 0 ]; then
      set -x
      ${perSystem.home-manager.default}/bin/home-manager switch --flake "${flake}" "$@"
      set +x

      if ${pkgs.attic-client}/bin/attic cache info ${cacheName} 2>/dev/null; then
        printf "\n=> Pushing home closure to binary cache (${cacheName})\n"
        temp="$(mktemp -d)"
        set -x
        cd "$temp"
        ${perSystem.home-manager.default}/bin/home-manager build --flake "${flake}" "$@"
        ${pkgs.attic-client}/bin/attic push ${cacheName} ./result || true
        rm -f ./result
        cd - >/dev/null
        rmdir "$temp"
      fi
    else
      echo "Nothing to be done for user '$USER'"
    fi
  '';
}
