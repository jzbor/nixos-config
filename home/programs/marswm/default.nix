{ pkgs, lib, config, ... }:

{
  #xdg.configFile."marswm".source = ./files;
  home.packages = with pkgs; [
    # required by key bindings
    libcanberra-gtk3
    maim
    playerctl
    pulseaudio
    coreutils  # tee
    xclip
  ];


  xdg.configFile = {
    "marswm/buttonbindings_ext.yaml".source = ./buttonbindings_ext.yaml;
    "marswm/keybindings_ext.yaml".source = ./keybindings_ext.yaml;
    "marswm/rules.yaml".source = ./rules.yaml;

    "marswm/marswm.yaml".text = builtins.concatStringsSep "\n" [
      (builtins.readFile ./marswm.yaml)
      ''
        theming:
          active_color: 0x${config.colorScheme.colors.base02}
          inactive_color: 0x${config.colorScheme.colors.base00}
          border_color: 0x${config.colorScheme.colors.base00}
          no_decoration:
            frame_width: [2, 2, 2, 2]
          font: Noto Sans:size=8
      ''
    ];

    "marswm/marsbar.yaml".text = builtins.concatStringsSep "\n" [
      (builtins.readFile ./marsbar.yaml)
      ''
        style:
          background: 0x${config.colorScheme.colors.base00}
          font: Noto Sans
          workspaces:
            foreground: 0x${config.colorScheme.colors.base00}
            inner_background: 0x${config.colorScheme.colors.base04}
            outer_background: 0x${config.colorScheme.colors.base00}
            padding_horz: 0
            padding_vert: 0
            text_padding_horz: 10
            text_padding_vert: 4
            spacing: 0
          title:
            foreground: 0x${config.colorScheme.colors.base0F}
            background: 0x${config.colorScheme.colors.base00}
          status:
            foreground: 0x${config.colorScheme.colors.base00}
            inner_background: 0x${config.colorScheme.colors.base01}
            outer_background: 0x${config.colorScheme.colors.base00}
            padding_horz: 4
            padding_vert: 4
            text_padding_horz: 5
            text_padding_vert: 0
            spacing: 4
      ''
    ];
  };

}
