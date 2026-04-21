config:

''
  * {
    font-family: Noto Sans;
    font-size: 13pt;
    min-height: 0;
    border-radius: 0px;
  }

  window#waybar {
    color: #${config.colorScheme.palette.base0F};
    background: #${config.colorScheme.palette.base00};
  }

  .modules-right {
    padding: 4px;
  }

  #workspaces button {
    border: none;
    padding: 0px 8px;
    background: #${config.colorScheme.palette.base04};
    color: #${config.colorScheme.palette.base00};
  }

  #workspaces button.hidden {
    color: #${config.colorScheme.palette.base08};
  }

  #workspaces button.active {
    background: #${config.colorScheme.palette.base00};
    color: #${config.colorScheme.palette.base04};
  }

  #workspaces button:hover {
    background: #${config.colorScheme.palette.base00};
    color: #${config.colorScheme.palette.base04};
    box-shadow: none;
  }

  #workspaces button.active:hover {
    background: #${config.colorScheme.palette.base04};
    color: #${config.colorScheme.palette.base00};
    box-shadow: none;
  }

  #pulseaudio {
    padding: 0 4pt;
    color: #${config.colorScheme.palette.base00};
    background: #${config.colorScheme.palette.base01};
  }

  #custom-battery {
    padding: 0 4pt;
    color: #${config.colorScheme.palette.base00};
    background: #${config.colorScheme.palette.base01};
  }

  #clock {
    padding: 0 4pt;
    color: #${config.colorScheme.palette.base00};
    background: #${config.colorScheme.palette.base01};
  }

  #tray {
    padding: 0 4pt;
    color: #${config.colorScheme.palette.base00};
    background: #${config.colorScheme.palette.base01};
  }

''
