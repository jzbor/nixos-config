{ pkgs, nix-colors, ... }:

{
  imports = [
    ./toolkits.nix
    ./xresources.nix
  ];

  # Color scheme
  colorScheme =
    let name = "apprentice";
    in nix-colors.lib-core.schemeFromYAML "${name}" (builtins.readFile ./colorschemes/${name}.yaml);
}
