{ pkgs, inputs, ... }: {
  home.packages = [
    # (import ./packages.nix { inherit pkgs inputs; }).xdg-xmenu
    pkgs.nix
    (pkgs.callPackage ./all.nix { inherit inputs; })
  ];
}
