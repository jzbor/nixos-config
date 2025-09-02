{ inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModule

    ./toolkits.nix
    ./xresources.nix
  ];

  # Color scheme
  colorScheme =
    let name = "apprentice";
    in inputs.nix-colors.lib-core.schemeFromYAML "${name}" (builtins.readFile ./colorschemes/${name}.yaml);
}
