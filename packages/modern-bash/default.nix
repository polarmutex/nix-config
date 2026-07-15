{
  lib,
  stdenv,
  bashInteractive,
  bash-completion,
  blesh,
  starship,
  fzf,
  zoxide,
  eza,
  bat,
  ripgrep,
  writeText,
  ...
}: let
  rcFile = writeText "modern-bash-rc" ''
    # ble.sh: only load in interactive shells — non-interactive contexts (deploy,
    # scripts, dumb terminals) get a plain bash experience without errors.
    [[ $- == *i* ]] && source ${blesh}/share/blesh/ble.sh --noattach

    # Bash completion
    if [[ -f ${bash-completion}/etc/profile.d/bash_completion.sh ]]; then
      source ${bash-completion}/etc/profile.d/bash_completion.sh
    fi

    # History
    HISTSIZE=50000
    HISTFILESIZE=100000
    HISTCONTROL=ignoreboth:erasedups
    HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
    shopt -s histappend
    shopt -s globstar
    shopt -s cdspell
    shopt -s autocd

    # Interactive-only: fzf, zoxide, starship, ble.sh options
    if [[ $- == *i* ]]; then
      # fzf keybindings and completions (Ctrl-R, Ctrl-T, Alt-C)
      eval "$(${fzf}/bin/fzf --bash)"
      export FZF_DEFAULT_OPTS="--height 40% --reverse --border --info=inline"
      export FZF_CTRL_T_OPTS="--preview '${bat}/bin/bat --color=always --line-range :100 {} 2>/dev/null || cat {}'"

      # zoxide — smarter cd (use 'z' to jump, 'zi' for interactive)
      eval "$(${zoxide}/bin/zoxide init bash)"

      # Starship prompt (skip under dumb terminals)
      if [[ "$TERM" != "dumb" ]]; then
        eval "$(${starship}/bin/starship init bash)"
      fi

      # ble.sh options (only set if ble.sh actually loaded)
      if [[ -n "''${BLE_VERSION-}" ]]; then
        bleopt history_share=1
        bleopt prompt_ps1_transient='trim:same-dir'
        ble-bind -f up   history-search-backward
        ble-bind -f down history-search-forward
        ble-attach
      fi
    fi

    # Aliases (available in all contexts)
    alias ls='${eza}/bin/eza --group-directories-first --icons=auto'
    alias ll='${eza}/bin/eza -lbGF --git --group-directories-first --icons=auto'
    alias la='${eza}/bin/eza -labGF --git --group-directories-first --icons=auto'
    alias tree='${eza}/bin/eza --tree'
    alias cat='${bat}/bin/bat --style=auto'
    alias grep='${ripgrep}/bin/rg'
    alias diff='diff --color=auto'
  '';
in
  stdenv.mkDerivation {
    pname = "modern-bash";
    version = "1.0.0";
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/bash << 'SHEOF'
      #!BASHPATH
      exec BASHPATH --rcfile RCFILE "$@"
      SHEOF
      sed -i \
        -e "s|BASHPATH|${bashInteractive}/bin/bash|g" \
        -e "s|RCFILE|${rcFile}|g" \
        $out/bin/bash
      chmod +x $out/bin/bash
    '';

    passthru.shellPath = "/bin/bash";

    meta = {
      description = "Bash with ble.sh, starship, fzf, zoxide, and modern defaults";
      mainProgram = "bash";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.linux;
    };
  }
