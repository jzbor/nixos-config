{ pkgs, self, systemPackages, ... }: pkgs.writeShellApplication {
  name = "rebuild-home";
  runtimeInputs = with pkgs; [
    attic-client
    systemPackages.self.nix
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
      path=""
      if nix eval "${self}#homeConfigurations.$USER@$(< /etc/hostname)" --apply "x: true" >/dev/null 2>&1; then
        path="$(nix build --no-link --print-out-paths "${self}#homeConfigurations.$USER@$(< /etc/hostname).activationPackage")"
      else
        path="$(nix build --no-link --print-out-paths "${self}#homeConfigurations.$USER.activationPackage")"
      fi

      if test -z "$path"; then
        echo "Unable to build system path" >> /dev/stderr
        exit 1
      fi

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
