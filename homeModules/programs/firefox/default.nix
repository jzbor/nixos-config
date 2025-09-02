{ lib, config, ... }:

with lib;
let
  cfg = config.programs.firefox;
in mkIf cfg.enable {
  programs.firefox.profiles.default = {
    isDefault = true;

    # Default search engine
    search.force = true;
    search.default = "ddg";

    settings = {
      # Attempt to mitigate fingerprinting
      privacy.resistFingerprinting = true;
      privacy.trackingprotection.enabled = true;
      privacy.trackingprotection.fingerprinting.enabled = true;
      privacy.trackingprotection.cryptomining.enabled = true;

      # Isolate cookies and more on first party domain
      privacy.firstparty.isolate = true;

      # Disable geolocation tracking
      geo.enabled = false;

      # Cookies
      # 0 Accept all
      # 1 Block third-party
      # 2 Block all
      # 3 Block from unvisited
      # 4 New Cookie Jar policy
      network.cookie.cookieBehavior = 1;

      # Set start page
      browser.startup.homepage = "https://duckduckgo.com";

      # Disable history
      places.history.enabled = false;

      # Force enable hardware video decoding
      media.hardware-video-decoding.enabled = true;
      media.hardware-video-decoding.force-enabled = true;

      # Enable tab unloading on low memory
      browser.tabs.unloadOnLowMemory = true;

      # Set printer default format to A4
      print.print_paper_name = "iso_a4";
    };
  };
}
