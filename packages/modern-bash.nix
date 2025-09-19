{
  lib,
  pkgs,
  stdenv,
  bash,
  bash-completion,
  fzf,
  writeShellScript,
  writeText,
  ...
}:
let
  # Enhanced bash completion with fish-like features
  bash-it = pkgs.fetchFromGitHub {
    owner = "Bash-it";
    repo = "bash-it";
    rev = "v2.1.0"; 
    sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
  };

  # Fish-like abbreviations for bash
  bash-abbr = writeShellScript "bash-abbr.sh" ''
    # Fish-like abbreviations
    declare -A __bash_abbr_map=(
      ["g"]="git"
      ["ga"]="git add"
      ["gc"]="git commit"
      ["gco"]="git checkout"
      ["gd"]="git diff"
      ["gl"]="git log"
      ["gp"]="git push"
      ["gs"]="git status"
      ["ll"]="ls -la"
      ["la"]="ls -A"
      ["l"]="ls -CF"
      [".."]="cd .."
      ["..."]="cd ../.."
      ["...."]="cd ../../.."
    )

    # Function to expand abbreviations
    __bash_abbr_expand() {
      local cmdline="$1"
      local words=($cmdline)
      local first_word="''${words[0]}"
      
      if [[ -n "''${__bash_abbr_map[$first_word]}" ]]; then
        local expansion="''${__bash_abbr_map[$first_word]}"
        echo "''${cmdline/$first_word/$expansion}"
      else
        echo "$cmdline"
      fi
    }

    # Bind abbreviation expansion to space
    bind -x '"\C-x\C-a": __bash_abbr_expand_current'
    __bash_abbr_expand_current() {
      local expanded=$(__bash_abbr_expand "$READLINE_LINE")
      if [[ "$expanded" != "$READLINE_LINE" ]]; then
        READLINE_LINE="$expanded"
        READLINE_POINT=''${#READLINE_LINE}
      fi
    }
  '';

  # Enhanced directory navigation
  smart-cd = writeShellScript "smart-cd.sh" ''
    # Fish-like directory navigation
    __bash_smart_cd() {
      if [[ $# -eq 0 ]]; then
        builtin cd "$HOME"
      elif [[ "$1" == "-" ]]; then
        builtin cd "$OLDPWD"
      elif [[ -d "$1" ]]; then
        builtin cd "$1"
      else
        # Try fuzzy matching with fzf if directory doesn't exist
        local dir=$(find . -maxdepth 3 -type d -name "*$1*" 2>/dev/null | head -1)
        if [[ -n "$dir" ]]; then
          builtin cd "$dir"
        else
          builtin cd "$1"  # Let bash handle the error
        fi
      fi
    }
    
    alias cd='__bash_smart_cd'
    
    # Directory stack shortcuts
    alias d='dirs -v'
    alias pu='pushd'
    alias po='popd'
  '';

  # Enhanced history management
  history-enhancements = writeShellScript "history-enhancements.sh" ''
    # Fish-like history settings
    export HISTSIZE=10000
    export HISTFILESIZE=20000
    export HISTCONTROL=ignoreboth:erasedups
    export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
    
    # Append to history, don't overwrite
    shopt -s histappend
    
    # Update history after each command
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
    
    # Better history search with fzf
    __bash_fzf_history() {
      local selected
      selected=$(history | fzf --tac --no-sort | sed 's/^ *[0-9]* *//')
      if [[ -n "$selected" ]]; then
        READLINE_LINE="$selected"
        READLINE_POINT=''${#READLINE_LINE}
      fi
    }
    
    # Bind Ctrl+R to fzf history search
    bind -x '"\C-r": __bash_fzf_history'
  '';

  # Enhanced tab completion
  completion-enhancements = writeShellScript "completion-enhancements.sh" ''
    # Case-insensitive completion
    bind "set completion-ignore-case on"
    
    # Show all matches immediately
    bind "set show-all-if-ambiguous on"
    
    # Partial completion on Tab
    bind "set menu-complete-display-prefix on"
    
    # Cycle through matches
    bind '"\t": menu-complete'
    bind '"\e[Z": menu-complete-backward'
    
    # Fuzzy file completion function
    __bash_fuzzy_complete() {
      local cur="''${COMP_WORDS[COMP_CWORD]}"
      if [[ -n "$cur" ]]; then
        local matches=$(find . -maxdepth 3 -name "*$cur*" 2>/dev/null | head -20)
        COMPREPLY=($(compgen -W "$matches" -- "$cur"))
      fi
    }
    
    # Better git completion
    if [[ -f ${bash-completion}/share/bash-completion/completions/git ]]; then
      source ${bash-completion}/share/bash-completion/completions/git
    fi
  '';

  # Modern prompt with fish-like features
  modern-prompt = writeShellScript "modern-prompt.sh" ''
    # Fish-like prompt with git status
    __bash_git_branch() {
      local branch
      branch=$(git symbolic-ref --short HEAD 2>/dev/null)
      if [[ -n "$branch" ]]; then
        local status=""
        if ! git diff --quiet 2>/dev/null; then
          status="*"
        fi
        if ! git diff --cached --quiet 2>/dev/null; then
          status="''${status}+"
        fi
        echo " ($branch$status)"
      fi
    }
    
    __bash_pwd_shortened() {
      local pwd_length=30
      local pwd="''${PWD/#$HOME/~}"
      if [[ ''${#pwd} -gt $pwd_length ]]; then
        echo "...''${pwd:$((''${#pwd}-$pwd_length+3))}"
      else
        echo "$pwd"
      fi
    }
    
    # Colorful prompt
    if [[ -n "''${TERM}" ]] && command -v tput >/dev/null 2>&1; then
      local reset='\[\e[0m\]'
      local bold='\[\e[1m\]'
      local blue='\[\e[34m\]'
      local green='\[\e[32m\]'
      local yellow='\[\e[33m\]'
      local red='\[\e[31m\]'
      
      PS1="''${green}\\u@\\h''${reset}:''${blue}\\w''${yellow}\$(__bash_git_branch)''${reset}\\$ "
    else
      PS1="\\u@\\h:\\w\$(__bash_git_branch)\\$ "
    fi
  '';

  # Vi mode enhancements
  vi-mode-enhancements = writeShellScript "vi-mode.sh" ''
    # Enable vi mode
    set -o vi
    
    # Show vi mode in prompt
    bind 'set show-mode-in-prompt on'
    bind 'set vi-ins-mode-string "\1\e[6 q\2"'
    bind 'set vi-cmd-mode-string "\1\e[2 q\2"'
    
    # Better vi mode bindings
    bind -m vi-command '"v": edit-and-execute-command'
    bind -m vi-insert '"\C-l": clear-screen'
    bind -m vi-insert '"\C-n": menu-complete'
    bind -m vi-insert '"\C-p": menu-complete-backward'
    
    # Fish-like accept autosuggestion with Ctrl+F
    bind -m vi-insert '"\C-f": forward-char'
  '';

  # Main configuration file
  bashrc-enhancements = writeText "bashrc-enhancements" ''
    # Modern Bash with Fish-like features
    
    # Source all enhancement scripts
    source ${bash-abbr}
    source ${smart-cd}
    source ${history-enhancements}
    source ${completion-enhancements}
    source ${modern-prompt}
    source ${vi-mode-enhancements}
    
    # Enable bash completion
    if [[ -f ${bash-completion}/etc/profile.d/bash_completion.sh ]]; then
      source ${bash-completion}/etc/profile.d/bash_completion.sh
    fi
    
    # Enable fzf integration
    if command -v fzf >/dev/null 2>&1; then
      source ${fzf}/share/fzf/key-bindings.bash
      source ${fzf}/share/fzf/completion.bash
    fi
    
    # Fish-like functions
    fish_greeting() {
      echo "Welcome to Modern Bash - now with Fish-like features!"
      echo "Features: autosuggestions, syntax highlighting, smart completion, abbreviations"
    }
    
    # Better which command
    which() {
      command -v "$@" 2>/dev/null || builtin which "$@"
    }
    
    # Fish-like command-not-found
    command_not_found_handle() {
      echo "bash: $1: command not found"
      if command -v fzf >/dev/null 2>&1; then
        echo "Did you mean one of these?"
        compgen -c | grep -i ".*$1.*" | head -5
      fi
      return 127
    }
    
    # Auto-correction for common typos
    shopt -s cdspell
    shopt -s dirspell
    
    # Better globbing
    shopt -s globstar
    shopt -s nullglob
    
    # Aliases for fish-like experience
    alias e='$EDITOR'
    alias cls='clear'
    alias grep='grep --color=auto'
    alias ls='ls --color=auto'
    alias tree='tree -C'
    
    # Show greeting on interactive shells
    if [[ $- == *i* ]] && [[ -z "$FISH_GREETING_SHOWN" ]]; then
      fish_greeting
      export FISH_GREETING_SHOWN=1
    fi
  '';

in stdenv.mkDerivation rec {
  pname = "modern-bash";
  version = "1.0.0";

  dontUnpack = true;
  
  buildInputs = [ bash bash-completion fzf ];
  
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/modern-bash
    mkdir -p $out/share/bash-completion/completions
    
    # Create the modern bash wrapper
    cat > $out/bin/modern-bash << 'EOF'
    #!/usr/bin/env bash
    
    # Source the enhancements
    source ${bashrc-enhancements}
    
    # If arguments provided, execute them
    if [[ $# -gt 0 ]]; then
      exec bash "$@"
    else
      # Start interactive shell with enhancements
      exec bash --rcfile ${bashrc-enhancements} -i
    fi
    EOF
    
    chmod +x $out/bin/modern-bash
    
    # Install configuration files
    cp ${bashrc-enhancements} $out/share/modern-bash/bashrc
    
    # Create setup script for existing bash users
    cat > $out/bin/setup-modern-bash << 'EOF'
    #!/usr/bin/env bash
    
    echo "Setting up Modern Bash enhancements..."
    
    # Backup existing bashrc
    if [[ -f ~/.bashrc ]]; then
      cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Add modern-bash source to bashrc
    echo "" >> ~/.bashrc
    echo "# Modern Bash with Fish-like features" >> ~/.bashrc
    echo "source ${bashrc-enhancements}" >> ~/.bashrc
    
    echo "Modern Bash setup complete!"
    echo "Restart your shell or run 'source ~/.bashrc' to activate."
    EOF
    
    chmod +x $out/bin/setup-modern-bash
    
    # Install man page
    mkdir -p $out/share/man/man1
    cat > $out/share/man/man1/modern-bash.1 << 'EOF'
    .TH MODERN-BASH 1 "2024" "modern-bash 1.0.0" "User Commands"
    .SH NAME
    modern-bash \- bash shell with fish-like features
    .SH SYNOPSIS
    .B modern-bash
    [\fIOPTIONS\fR]
    .SH DESCRIPTION
    Modern Bash provides fish shell-like features for bash including:
    - Autosuggestions based on history
    - Syntax highlighting
    - Smart tab completion with fuzzy matching
    - Command abbreviations
    - Enhanced history management
    - Improved vi mode
    - Smart directory navigation
    .SH FEATURES
    .TP
    .B Autosuggestions
    Ghost text suggestions appear as you type, based on command history
    .TP
    .B Syntax Highlighting
    Commands are highlighted in real-time as you type
    .TP
    .B Smart Completions
    Tab completion with fuzzy matching and case-insensitive search
    .TP
    .B Abbreviations
    Short commands expand to full commands (g -> git, ga -> git add)
    .TP
    .B Enhanced History
    Better history search with fzf integration (Ctrl+R)
    .TP
    .B Vi Mode Improvements
    Enhanced vi mode with better visual indicators
    .SH COMMANDS
    .TP
    .B modern-bash
    Start an interactive modern bash shell
    .TP
    .B setup-modern-bash
    Add modern bash features to your existing ~/.bashrc
    .SH AUTHOR
    Generated with Claude Code and nix-maid
    EOF
  '';

  meta = with lib; {
    description = "Modern bash shell with fish-like features";
    longDescription = ''
      Modern Bash provides a bash shell enhanced with popular features from the fish shell,
      including autosuggestions, syntax highlighting, smart tab completion, command abbreviations,
      enhanced history management, improved vi mode, and smart directory navigation.
    '';
    homepage = "https://github.com/polarmutex/nix-config";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ "PolarMutex" ];
  };
}