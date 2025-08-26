_:

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
        Default = "ddg";
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
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
        };
        "{7a7b1d36-d7a4-481b-92c6-9f5427cb9eb1}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4253375/wallabagger-latest.xpi";
        };
        "{f18f0257-10ad-4ff7-b51e-6895edeccfc8}" = {
          installation_mode = "force_installed";
          install_url = "https://files.jzbor.de/blobs/netflix-1080p.xpi";
        };
      };
    };
  };

  # Enable new input backend
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
