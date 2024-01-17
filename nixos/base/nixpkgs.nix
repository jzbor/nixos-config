{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.jzbor-overlay.overlays.default
  ];
}
