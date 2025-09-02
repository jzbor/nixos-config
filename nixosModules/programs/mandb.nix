{ config, lib, ... }:

lib.mkIf config.documentation.man.man-db.enable {
  systemd.services.update-mandb = {
    serviceConfig.Type = "oneshot";
    path = [ config.documentation.man.man-db.package ];
    script = ''
      time mandb
    '';
  };
  systemd.timers.update-mandb = {
    wantedBy = [ "timers.target" ];
    partOf = [ "update-mandb.service" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "update-mandb.service";
    };
  };
}
