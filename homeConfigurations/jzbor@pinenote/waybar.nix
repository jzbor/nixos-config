{ ... }:

{
  programs.waybar = {
    enable = true;
    style = ./waybar-style.css;
    settings = {
      mainBar = {
        "layer" = "top";
        "modules-left" = [ "sway/workspaces" ];
        "modules-center" = [ "custom/keyboard" "custom/applications" "custom/refresh" "custom/window" ];
        "modules-right" = [ "custom/travel-mode" "custom/eink-display" "battery" "clock" "tray" ];
        "sway/window" = {
          "max-length" = 50;
        };
        "battery" = {
          "format" = "{capacity}%";
          "format-charging" = "{capacity}% charging";
        };
        "custom/keyboard" = {
          "format" = "kbd";
          "on-click" = "pkill -SIGRTMIN wvkbd-mobintl";
        };
        "custom/applications" = {
          "format" = "run";
          # "on-click" = "(PATH=$HOME/.nix-profile/bin $HOME/.nix-profile/bin/xdg-xmenu; printf 'abort\ttrue\n') | xmenu -p 0x0 | sh";
          # "on-click" = "pkill -SIGUSR2 wvkbd-mobintl && sway exec wmenu-run -N ffffff -n 000000 -M 000000 -m ffffff -S 000000 -s ffffff -f 'mono 12' -p run -l 10; pkill -SIGUSR1 wvkbd-mobintl";
          # "on-click" = "cat ~/.config/app_menu | xmenu -p 0x0 | sh";
          # "on-click" = "swaymsg exec ~/.nix-profile/bin/pn-wmenu";
        };
        "custom/refresh" = {
          "format" = "ref";
          "on-click" = "dbus-send --system --print-reply --dest=org.pinenote.ebc /ebc org.pinenote.ebc.TriggerGlobalRefresh";
        };
        "custom/eink" = {
          "format" = "eink";
          "on-click" = "cat ~/.config/eink_menu | xmenu -p 0x0 | sh";
        };
        "custom/eink-display" = {
          "exec" = "pn-eink-status";
          "on-click" = "cat ~/.config/eink_menu | xmenu -p 0x0 | sh";
        };
        "custom/window" = {
          "format" = "win";
          "on-click" = "cat ~/.config/window_menu | xmenu -p 0x0 | sh";
        };
        "custom/travel-mode" = {
          "hide-empty-text" = true;
          "interval" = 60;
          "exec" = "pinenotectl travel-mode | cut -f 2 | sed 's/on//'";
        };
        "spacing" = 15;
        "margin-top" = 4;
      };
    };
  };
}
