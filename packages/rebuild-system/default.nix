{ self, pkgs, systemPackages, ... }: pkgs.writeShellApplication {
  name = "rebuild-system";
  runtimeInputs = with pkgs; [
    attic-client
    systemPackages.self.nix
  ];
  text = let
    cacheName = "desktop";
    activator = pkgs.writeShellScriptBin "nixos-activator" ''
      set -x
      path="$(nix build --no-link --print-out-paths "${self}#nixosConfigurations.$(< /etc/hostname).config.system.build.toplevel")"
      if test -z "$path"; then
        echo "Unable to build system path" >> /dev/stderr
        exit 1
      fi

      nix-env --profile /nix/var/nix/profiles/system --set "$path"
      "$path/bin/switch-to-configuration" switch
      set +x
      echo "$path"
    '';
  in ''
    printf "\n=> Rebuilding system\n"

    if [ "$UID" = 0 ]; then
      SUDO=""
    elif command -v doas >/dev/null; then
      SUDO="doas"
    elif command -v sudo >/dev/null; then
      SUDO="sudo"
    fi

    prev_path="$(readlink -f /run/current-system)"
    path="$($SUDO ${activator}/bin/nixos-activator | tail -n1)"

    if command -v nix-sweep >/dev/null; then
      nix-sweep compare --concise --no-changed "$prev_path" "$path"
      echo
    fi

    if attic cache info ${cacheName} 2>/dev/null; then
      printf "\n=> Pushing system closure to binary cache (${cacheName})\n"
      set -x
      attic push ${cacheName} "$path" || true
    fi
  '';
}
