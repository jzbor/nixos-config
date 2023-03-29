{ lib, config, pkgs, ... }:

{
  # Installed programs for marswm environment
  programs.light.enable = true;
  programs.nm-applet.enable = true;
  environment.systemPackages = with pkgs; [
    arandr
    buttermilk
    dmenu
    lxappearance
    marswm
    picom
    rofi
    xmenu
  ];

  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "marswm";
      start = "marswm & buttermilk";
    }
    {
      manage = "desktop";
      name = "marswm-dev";
      start = "~/Programming/Rust/marswm/target/debug/marswm";
    }
  ];
}
