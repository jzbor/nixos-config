{ self, pkgs, inputs, ... }:

let
  inherit (pkgs) lib;
  shelly-exporter-config = pkgs.writers.writeYAML "shelly-exporter-config.yaml" {
    devices = [
      {
        name = "shelly-01";
        host = "10.10.0.201";
      }
      {
        name = "shelly-02";
        host = "10.10.0.202";
      }
      {
        name = "shelly-03";
        host = "10.10.0.203";
      }
      {
        name = "shelly-04";
        host = "10.10.0.204";
      }
    ];
  };
in {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        enforce_domain = false;  # insecure
        enable_gzip = true;
        domain = "localhost";

        # Alternatively, if you want to serve Grafana from a subpath:
        # domain = "your.domain";
        # root_url = "https://your.domain/grafana/";
        # serve_from_sub_path = true;
      };

      # Prevents Grafana from phoning home
      analytics.reporting_enabled = false;

      security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
    };
  };

  services.prometheus = {
    enable = true;
    port = 3001;
    globalConfig.scrape_interval = "15s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "shelly";
        static_configs = [{
          targets = [ "localhost:4001" ];
        }];
      }
    ];
  };

  users.users."shelly-exporter" = {
    isSystemUser = true;
    group = "shelly-exporter";
  };
  users.groups."shelly-exporter" = {};

  systemd.services.shelly-exporter = {
    description = "Prometheus shelly-exporter";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "shelly-exporter";
      ExecStart = "${inputs.parcels.packages.x86_64-linux.shelly-exporter}/bin/shelly-exporter -config=${shelly-exporter-config} -web.listen-address :4001";

      # hardening
      PrivateDevices = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectSystem = "full";
      RestrictSUIDSGID = true;
    };
  };
}
