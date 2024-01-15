
{ pkgs, config, ... }:

{
  # Add rofi program to environment
  programs.rofi.enable = true;

  programs.rofi.theme = ./theme.rasi;
  xdg.configFile."rofi/theme.rasi".text = builtins.concatStringsSep "\n" [
    '' * {
      background:      #${config.colorScheme.colors.base00};
      argbbackground:  #${config.colorScheme.colors.base00}80;
      backgroundlight: #${config.colorScheme.colors.base08};
      transparent:     #00000000;
      foreground:      #${config.colorScheme.colors.base0F};
      urgent:          #${config.colorScheme.colors.base01};
      selected:        #${config.colorScheme.colors.base04};
    } ''
    (builtins.readFile ./theme.rasi)
  ];

  programs.rofi.extraConfig = {
    modi = "drun,ssh";
    font = "FiraCode Nerd Font 14";
    show-icons = true;
    icon-theme = "Numix-Circle";
    drun-display-format = "{name} \\n<span weight= 'light' size='small'><i>{comment}</i></span>";
    sidebar-mode = true;
    disable-history = false;

    kb-remove-to-eol = "";
    kb-remove-char-back = "BackSpace";
    kb-mode-complete = "";
    kb-accept-entry = "Return,KP_Enter";

    kb-row-left = "Control+h";
    kb-row-down = "Control+j";
    kb-row-up = "Control+k";
    kb-row-right = "Control+l";
  };

  # TODO switch when buttermilk overlay is available in flake
  programs.rofi.terminal = "${pkgs.buttermilk}/bin/buttermilk";
}
