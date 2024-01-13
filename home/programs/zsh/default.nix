{ pkgs, lib, config, ... }:

{
  programs.zsh = {
    enable = true;

    # Search, completion and suggestions
    historySubstringSearch.enable = true;
    #enableAutosuggestions = true;

    # History
    history = {
      expireDuplicatesFirst = true;
      extended = false;  # save timestamps
      ignoreDups = true;  # ignore duplicate entries
      ignoreSpace = true;  # ignore commands starting with a space

      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 10000;  # number of lines to save
      size = 10000;  # number of lines to keep
    };

    dotDir = ".config/zsh";

    # Highlighting
    syntaxHighlighting.enable = true;

    # Aliases
    shellAliases = {
      enter = "dev-shell -e";
      installed-nixos-packages = "nix path-info -shr /run/current-system | sort -hk2";
      installed-profile-packages = "nix path-info -shr \"$HOME/.nix-profile\" | sort -hk2";
      nixos-system-generations = "nix-env -p /nix/var/nix/profiles/system --list-generations";
      pin-nix-shell = "nix-instantiate shell.nix --indirect --add-root shell.drv";
      rgrep = "grep -RHIni --exclude-dir .git --exclude tags --color";
      sd = "cd $(switch-dir)";
      stored-nix-pkgs = "find /nix/store -maxdepth 1 | xargs du -sh | sort -h";
      valgrind = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes";
    };

    # Additional configuration
    initExtra = builtins.concatStringsSep "\n" [
      (builtins.readFile ./config.zsh)
      (builtins.readFile ./rprompt.zsh)
    ];
  };
}
