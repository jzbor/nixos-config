{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.jzbor-home.programs.captive-browser;
in {
  options.jzbor-home.programs.captive-browser = {
    enable = mkEnableOption "Install captive browser";
  };

  config = mkIf cfg.enable {
    # Add firefox to environment
    programs.firefox.enable = true;

    programs.firefox.profiles.captive-browser = {
      id = 1001;
      settings = {
        # assuming captive-browser proxy is socks5://localhost:1666
        "network.proxy.socks" = "localhost";
        "network.proxy.socks_port" = 1666;
        "network.proxy.socks_remote_dns" = true;
        "network.proxy.type" = 1;

        # disable https-only in case it interferes
        "dom.security.https_only_mode" = false;

        # enable custom theming
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        #TabsToolbar { display: none; }
      '';
    };

    xdg.configFile."captive-browser.toml".source = ./captive-browser.toml;

    xdg.desktopEntries.captive-browser = {
      name = "Captive Browser";
      exec = "${pkgs.captive-browser}/bin/captive-browser";
      categories = [ "Network" "System" "Utility" ];
      icon = "firefox";
    };
  };
}
