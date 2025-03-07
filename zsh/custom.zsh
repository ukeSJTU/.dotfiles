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

# Tmux Intelligent Session Management
if command -v tmux >/dev/null 2>&1; then
    # Check if the current environment is suitable for running tmux
    if [[ -z "$TMUX" &&
        $TERM != "screen-256color" &&
        $TERM != "screen" &&
        -z "$VSCODE_INJECTION" &&
        -z "$INSIDE_EMACS" &&
        -z "$EMACS" &&
        -z "$VIM" &&
        -z "$INTELLIJ_ENVIRONMENT_READER" ]]; then

        # Check if tmux should be forcibly started
        if [[ -n "$FORCE_TMUX" ]] || [[ -n "$SSH_CONNECTION" ]]; then
            # Determine session name
            if [[ -n "$TMUX_SESSION_NAME" ]]; then
                SESSION_NAME="$TMUX_SESSION_NAME"
            elif [[ -n "$SSH_CONNECTION" ]]; then
                SESSION_NAME="default-$(whoami)"
            else
                SESSION_NAME="local-$(whoami)"
            fi

            # Try to attach to an existing session, or create a new one if it doesn't exist
            if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
                # Session exists, attempt to attach
                tmux attach -t "$SESSION_NAME"
            else
                # Session does not exist, create a new session
                tmux new-session -s "$SESSION_NAME"

                # Set session timeout for automatic termination (if specified)
                if [[ -n "$TMUX_IDLE_TIMEOUT" ]]; then
                    tmux set-option -t "$SESSION_NAME" destroy-unattached on
                    tmux set-option -t "$SESSION_NAME" destroy-unattached-timeout "$TMUX_IDLE_TIMEOUT"
                fi
            fi

            # Check the exit behavior environment variable
            if [[ "$TMUX_EXIT_BEHAVIOR" == "kill" ]]; then
                # If set to "kill", terminate the session
                tmux kill-session -t "$SESSION_NAME"
            fi

            # Exit the current shell
            exit
        fi
        # If running in a local terminal and tmux is not forced, do nothing
    fi
fi

# yazi - open cwd when exiting from yazi
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# zsh Options
setopt HIST_IGNORE_ALL_DUPS
setopt AUTO_CD
