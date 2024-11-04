{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.programs.zsh;
in mkIf cfg.enable {
  programs.zsh = {
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
    shellAliases = with pkgs; {
      enter = "dev-shell -e";
      installed-nixos-packages = "nix path-info -shr /run/current-system | sort -hk2";
      installed-profile-packages = "nix path-info -shr \"$HOME/.nix-profile\" | sort -hk2";
      nixos-system-generations = "nix-env -p /nix/var/nix/profiles/system --list-generations";
      pin-nix-shell = "nix-instantiate shell.nix --indirect --add-root shell.drv";
      rgrep = "grep -RHIni --exclude-dir .git --exclude tags --color";
      sd = "cd $(switch-dir)";
      stored-nix-pkgs = "find /nix/store -maxdepth 1 | xargs du -sh | sort -h";
      valgrind = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes";
      cp = "${uutils-coreutils-noprefix}/bin/cp --progress";
      mv = "${uutils-coreutils-noprefix}/bin/mv --progress";
      mkdir = "mkdir --verbose --parents";
      ls = "${uutils-coreutils-noprefix}/bin/ls --color=auto --human-readable";
      lisho-edit = "ssh ln.jzbor.de -t nvim /var/lib/lisho/mappings";
      news = "cliflux";
      attic-size = "ssh root@fsn1-03.jzbor.de du -sh /var/lib/private/atticd/*";
      typst-wc = "sh -c 'typst compile -f pdf $0 /dev/stdout | nix shell nixpkgs#poppler_utils -c pdftotext - - | wc'";
      typst-to-text = "sh -c 'typst compile -f pdf $0 /dev/stdout | nix shell nixpkgs#poppler_utils -c pdftotext - -'";

      build = "nix build";
      run = "nix run";
      shell = "nix shell";
      develop = "nix develop";

      gcc-sp = "gcc -std=c11 -pedantic -Wall -Werror -D_XOPEN_SOURCE=700";
      sp-happy = "nix run sp#happy --";
      sp-fetch = "nix run sp#fetch --";
    };

    sessionVariables = {
      SP_REMOTE = "wa94tiju@cipterm0.cip.cs.fau.de";
      SP_REMOTE_DIR = "korrektur";
      SP_TUE = "T06";
      SP_HAPPY_PATH = "/proj/i4sp2/sys/happy/happy";
    };

    # Additional configuration
    initExtra = builtins.concatStringsSep "\n" [
      (builtins.readFile ./config.zsh)
      (builtins.readFile ./prompt.zsh)
    ];
  };

  programs.nix-index.enable = false;
}
