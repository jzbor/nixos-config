{ flake, pkgs, pname, perSystem }: pkgs.writeShellApplication {
  name = pname;
  runtimeInputs = with pkgs; [
    attic-client
    perSystem.self.nix
  ];
  text = let
    cacheName = "desktop";
    activator = pkgs.writeShellScriptBin "nixos-activator" ''
      set -x
      path="$(nix build --no-link --print-out-paths "${flake}#nixosConfigurations.$(< /etc/hostname).config.system.build.toplevel")"
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

    path="$($SUDO ${activator}/bin/nixos-activator | tail -n1)"

    if attic cache info ${cacheName} 2>/dev/null; then
      printf "\n=> Pushing system closure to binary cache (${cacheName})\n"
      set -x
      attic push ${cacheName} "$path" || true
    fi
  '';
}
