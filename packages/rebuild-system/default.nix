{ flake, pkgs, pname }: pkgs.writeShellApplication {
  name = pname;
  runtimeInputs = with pkgs; [
    attic-client
    nixos-rebuild
  ];
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
        path="$(nix build --no-link --print-out-paths ".#nixosConfigurations.$(< /etc/hostname).config.system.build.toplevel")"
        $SUDO nix-env --profile /nix/var/nix/profiles/system --set "$path"
        $SUDO "$path/bin/switch-to-configuration" switch
        set +x

        if attic cache info ${cacheName} 2>/dev/null; then
          printf "\n=> Pushing system closure to binary cache (${cacheName})\n"
          set -x
          attic push ${cacheName} /run/current-system || true
        fi
  '';
}
