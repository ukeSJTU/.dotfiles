# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"
starship config palette $STARSHIP_THEME

# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/git-completion.bash
fpath=($HOME/.config/zsh $fpath)
autoload -Uz compinit && compinit

# fzf
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_DEFAULT_COMMAND='rg --hidden -l ""' # Include hidden files

bindkey "ç" fzf-cd-widget # Fix for ALT+C on Mac

# fd - cd to selected directory
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2>/dev/null | fzf +m) &&
        cd "$dir"
}

# fh - search in your command history and execute selected command
fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# Tmux
# Always work in a tmux session if Tmux is installed
if command -v tmux >/dev/null 2>&1; then
    # Check if the current environment is suitable for tmux
    if [[ -z "$TMUX" &&
        $TERM != "screen-256color" &&
        $TERM != "screen" &&
        -z "$VSCODE_INJECTION" &&
        -z "$INSIDE_EMACS" &&
        -z "$EMACS" &&
        -z "$VIM" &&
        -z "$INTELLIJ_ENVIRONMENT_READER" ]]; then
        # Try to attach to the default tmux session, or create a new one if it doesn't exist
        if tmux attach -t default 2>/dev/null; then
            # If attach succeeds, do nothing
            :
        else
            # If attach fails, create a new session
            tmux new -s default
            # Exit the shell only if the tmux session is terminated (not detached)
            exit
        fi
    fi
fi
