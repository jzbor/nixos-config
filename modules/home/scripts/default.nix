{ pkgs, inputs, perSystem, ... }: {
  home.packages = [
    pkgs.nix
    (pkgs.callPackage ./all.nix { inherit pkgs inputs perSystem; })
  ];
}
