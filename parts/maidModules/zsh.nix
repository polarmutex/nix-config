{
  # Interactive zsh config for a user's ~/.zshrc. The system side still needs
  # `programs.zsh.enable` (NixOS requires it for a zsh login shell); set
  # `enableGlobalCompInit = false` and `promptInit = ""` there so compinit and
  # the prompt are only set up here.
  flake.maidModules.zsh = {
    pkgs,
    lib,
    ...
  }: let
    # Generate init scripts at build time instead of `eval "$(tool init zsh)"`
    # on every shell start.
    initScript = name: cmd:
      pkgs.runCommand "${name}-init.zsh" {} "${cmd} > $out";

    starshipInit = initScript "starship" "${lib.getExe pkgs.starship} init zsh --print-full-init";
    zoxideInit = initScript "zoxide" "${lib.getExe pkgs.zoxide} init zsh";
    direnvInit = initScript "direnv" "${lib.getExe pkgs.direnv} hook zsh";

    zshrc =
      pkgs.writeText "zshrc"
      # zsh
      ''
        # --- History -------------------------------------------------------
        HISTFILE="''${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
        [[ -d ''${HISTFILE:h} ]] || mkdir -p ''${HISTFILE:h}
        HISTSIZE=100000
        SAVEHIST=100000
        setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS \
          HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY SHARE_HISTORY HIST_FCNTL_LOCK

        # --- Options -------------------------------------------------------
        setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT \
          INTERACTIVE_COMMENTS EXTENDED_GLOB NO_BEEP

        # --- Completion ----------------------------------------------------
        _zcache="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
        [[ -d $_zcache ]] || mkdir -p $_zcache
        zmodload zsh/complist
        autoload -Uz compinit
        compinit -d "$_zcache/zcompdump-$ZSH_VERSION"
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$_zcache/compcache"
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*:git-checkout:*' sort false
        # fzf-tab replaces the menu
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
        unset _zcache

        # --- Vi mode -------------------------------------------------------
        bindkey -v
        KEYTIMEOUT=1
        # Backspace / ^W / ^U past the insert point, like vim with backspace=2
        bindkey -M viins '^?' backward-delete-char '^H' backward-delete-char \
          '^W' backward-kill-word '^U' backward-kill-line
        # Prefix history search on arrows / j k
        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey -M viins '^[[A' up-line-or-beginning-search '^[OA' up-line-or-beginning-search \
          '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search
        bindkey -M vicmd 'k' up-line-or-beginning-search 'j' down-line-or-beginning-search
        # `v` in normal mode edits the command line in $EDITOR
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd 'v' edit-command-line
        # Cursor shape: beam in insert, block in normal (starship wraps this)
        zle-keymap-select() {
          if [[ $KEYMAP == vicmd ]]; then print -n '\e[2 q'; else print -n '\e[6 q'; fi
        }
        zle-line-init() { print -n '\e[6 q' }
        zle -N zle-keymap-select
        zle -N zle-line-init

        # --- Plugins (order matters) ----------------------------------------
        # fzf: ^R history, ^T files, Alt-C cd (completion is left to fzf-tab)
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        # fzf-tab: after compinit, before widget-wrapping plugins
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        source ${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
        bindkey -M viins '^F' autosuggest-accept
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

        # --- Tools ---------------------------------------------------------
        export DIRENV_LOG_FORMAT=""
        source ${direnvInit}
        source ${zoxideInit}
        source ${starshipInit}
      '';
  in {
    packages = [pkgs.zoxide];
    file.home.".zshrc".source = zshrc;
    file.xdg_config."direnv/direnvrc".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
  };
}
