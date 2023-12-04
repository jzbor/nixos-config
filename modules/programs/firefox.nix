{ config, pkgs, ... }:

{
  programs.firefox = {
    policies = {
      DisablePocket = true;
      DisableFormHistory = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
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
        "gdpr@cavi.au.dk" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/consent-o-matic/latest.xpi";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
      };
    };
  };

  # Enable new input backend
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
