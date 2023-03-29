{ config, pkgs, ... }:

{
  programs.firefox = {
    policies = {
      DisablePocket = true;
      DisableFormHistory = true;
      EnableTrackingProtection = true;
      Cookies = {
        AcceptThirdParty = "never";
        RejectTracker = true;
      };
      SearchEngines = {
        Default = "DuckDuckGo";  # does not seem to be working
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
    };
  };

  # Enable new input backend
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
