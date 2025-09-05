{ pkgs, lib, inputs, ... }:


let
in {
  wayland.windowManager.sway = {
    enable = true;

    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      menu = "menu-run -N ffffff -n 000000 -M 000000 -m ffffff -S 000000 -s ffffff -f \"mono 12\" -p run -l 10";
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      input."*" = {
        xkb_layout = "us,de";
        xkb_options = "caps:escape_shifted_capslock,altwin:swap_alt_win,grp:lwin_switch";
        map_to_output = "DPI-1";
      };

      output."DPI-1" = {
        transform = "270";
        scale = "2";
      };

      keybindings = lib.mkAfter {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Delete" = "kill";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Control+BackSpace" = "reload";

        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";

        "${modifier}+s" = "stacking";
        "${modifier}+c" = "tabbed";
        "${modifier}+t" = "split";

        "${modifier}+period" = "workspace next";
        "${modifier}+comma" = "workspace prev";
        "${modifier}+tab" = "workspace back_and_forth";
      };

      startup = [
        { command = "swaybg -c ffffff"; }
        { command = "exec ${pkgs.wvkbd}/bin/wvkbd-mobintl -L 200 --bg 000000 --fg ffffff --text 000000 --fg-sp ffffff --text-sp 000000 --hidden"; }
        { command = "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'HighContrast'"; }
        { command = "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme 'HighContrast'"; }
        { command = "waybar"; }
        { command = "sleep 10 && update-lock-screen"; }
      ];

      colors = {
        focused = rec {
          border = "#000000";
          background = "#000000";
          text = "#ffffff";
          indicator = border;
          childBorder = border;
        };
        focusedInactive = rec {
          border = "#ffffff";
          background = "#ffffff";
          text = "#000000";
          indicator = border;
          childBorder = border;
        };
        unfocused = rec {
          border = "#000000";
          background = "#ffffff";
          text = "#000000";
          indicator = border;
          childBorder = border;
        };
      };

      bars = [];
    };

    extraConfig = ''
      default_orientation vertical
    '';
  };
}
