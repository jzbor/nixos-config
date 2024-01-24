{ pkgs, config, inputs, ... }:

{
  hardware.deviceTree.enable = true;
  hardware.deviceTree.name = "rockchip/rk3588-rock-5b.dtb";
}
