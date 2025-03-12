{ pkgs, pname, flake }: pkgs.writeShellApplication {
  name = pname;
  runtimeInputs = with pkgs; [
    attic-client
    home-manager
  ];
  text = let
    cacheName = "desktop";
  in ''
    printf "\n=> Rebuilding home\n"

    if [ "$UID" != 0 ]; then
      set -x
      home-manager switch --flake "${flake}" "$@"
      set +x

      if attic cache info ${cacheName} 2>/dev/null; then
        printf "\n=> Pushing home closure to binary cache (${cacheName})\n"

        homepath=""
        if [ -d "/nix/var/nix/profiles/per-user/$USER/home-manager" ]; then
          homepath="/nix/var/nix/profiles/per-user/$USER/home-manager"
        elif [ -d "$HOME/.local/state/nix/profiles/home-manager" ]; then
          homepath="$HOME/.local/state/nix/profiles/home-manager"
        else
          echo "Unable to find home-manager profile path" >/dev/stderr
          exit 1
        fi

        set -x
        attic push ${cacheName} "$homepath" || true
      fi
    else
      echo "Nothing to be done for user '$USER'"
    fi
  '';
}
