{ pkgs, pname, flake, perSystem }: pkgs.writeShellApplication {
  name = pname;
  runtimeInputs = with pkgs; [
    attic-client
    perSystem.self.nix
  ];
  text = let
    cacheName = "desktop";
  in ''
    printf "\n=> Rebuilding home\n"

    if [ "$UID" != 0 ]; then
      home_profile=""
      if [ -d "/nix/var/nix/profiles/per-user/$USER/home-manager" ]; then
        home_profile="/nix/var/nix/profiles/per-user/$USER/home-manager"
      elif [ -d "$HOME/.local/state/nix/profiles/home-manager" ]; then
        home_profile="$HOME/.local/state/nix/profiles/home-manager"
      else
        echo "Unable to find home-manager profile path" >/dev/stderr
        exit 1
      fi

      set -x
      path="$(nix build --no-link --print-out-paths "${flake}#homeConfigurations.$USER.activationPackage")"
      nix-env --profile "$home_profile" --set "$path"
      "$path/activate"
      set +x

      if attic cache info ${cacheName} 2>/dev/null; then
        printf "\n=> Pushing home closure to binary cache (${cacheName})\n"

        set -x
        attic push ${cacheName} "$path" || true
      fi
    else
      echo "Nothing to be done for user '$USER'"
    fi
  '';
}
