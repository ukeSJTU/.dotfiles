#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

# Install selected Homebrew formulae
install_custom_formulae() {
    info "Installing selected Homebrew formulae..."

    # List of formulae with descriptions
    declare -A formulae
    formulae=(
        ["git"]="Version control system"
        ["zsh"]="Z shell (interactive shell)"
        ["tmux"]="Terminal multiplexer"
        ["starship"]="Cross-shell prompt"
        ["wezterm"]="GPU-accelerated terminal emulator"
        ["yazi"]="Terminal file manager"
        ["fzf"]="Command-line fuzzy finder"
        ["ripgrep"]="Fast search tool (grep alternative)"
        ["bat"]="Cat clone with syntax highlighting"
        ["fd"]="Simple, fast alternative to find"
        ["lazygit"]="Simple terminal UI for git commands"
    )

    # Ask user which formulae to install
    echo "Select which formulae to install (y/n):"
    selected_formulae=()

    for formula in "${!formulae[@]}"; do
        read -p "  $formula - ${formulae[$formula]} [y/n]: " choice
        if [[ "$choice" == "y" ]]; then
            selected_formulae+=("$formula")
        fi
    done

    # Install selected formulae
    if [ ${#selected_formulae[@]} -eq 0 ]; then
        warning "No formulae selected for installation"
    else
        for formula in "${selected_formulae[@]}"; do
            if brew list "$formula" &>/dev/null; then
                warning "$formula is already installed"
            else
                info "Installing $formula..."
                dry_run brew install "$formula"
            fi
        done
    fi
}

# Install selected Homebrew casks
install_custom_casks() {
    info "Installing selected Homebrew casks..."

    # List of casks with descriptions
    declare -A casks
    casks=(
        ["visual-studio-code"]="Code editor"
        ["iterm2"]="Terminal emulator"
        ["rectangle"]="Window manager"
        ["alt-tab"]="Windows-style alt-tab window switcher"
        ["google-chrome"]="Web browser"
        ["firefox"]="Web browser"
        ["slack"]="Team communication"
        ["discord"]="Voice, video and text communication"
        ["spotify"]="Music streaming"
    )

    # Ask user which casks to install
    echo "Select which applications to install (y/n):"
    selected_casks=()

    for cask in "${!casks[@]}"; do
        read -p "  $cask - ${casks[$cask]} [y/n]: " choice
        if [[ "$choice" == "y" ]]; then
            selected_casks+=("$cask")
        fi
    done

    # Install selected casks
    if [ ${#selected_casks[@]} -eq 0 ]; then
        warning "No applications selected for installation"
    else
        for cask in "${selected_casks[@]}"; do
            if brew list --cask "$cask" &>/dev/null; then
                warning "$cask is already installed"
            else
                info "Installing $cask..."
                dry_run brew install --cask "$cask"
            fi
        done
    fi
}

# Run Brewfile if it exists and user wants to
run_brew_bundle() {
    if [ -f "$SCRIPT_DIR/../Brewfile" ]; then
        read -p "Run Brew Bundle to install packages from Brewfile? [y/n]: " choice
        if [[ "$choice" == "y" ]]; then
            info "Running Brew Bundle to install packages from Brewfile..."
            dry_run brew bundle --file="$SCRIPT_DIR/../Brewfile"
        else
            info "Skipping Brew Bundle"
        fi
    else
        warning "Brewfile not found, skipping Brew Bundle"
    fi
}

# Run the script if it's called directly
if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_custom_formulae
    install_custom_casks
    run_brew_bundle
fi
