#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/scripts/utils.sh
. $SCRIPT_DIR/scripts/prerequisites.sh
. $SCRIPT_DIR/scripts/symlinks.sh

info "Dotfiles installation initialized..."

# Display menu and get user choices
show_menu() {
    echo ""
    info "===================="
    info "Installation Options"
    info "===================="
    echo ""
    echo "Please select what you want to install/configure:"
    echo "1) Install prerequisites (Xcode CLI tools, Homebrew)"
    echo "2) Install apps and tools (via Homebrew)"
    echo "3) Set up dotfiles (create symbolic links)"
    echo "4) Install everything (1 + 2 + 3)"
    echo "5) Exit"
    echo ""
    read -p "Enter your choice [1-5]: " choice

    case $choice in
    1) install_prerequisites ;;
    2) install_apps ;;
    3) setup_dotfiles ;;
    4) install_all ;;
    5) exit 0 ;;
    *)
        warning "Invalid option. Please try again."
        show_menu
        ;;
    esac
}

# Install prerequisites
install_prerequisites() {
    printf "\n"
    info "===================="
    info "Prerequisites"
    info "===================="

    install_xcode
    install_homebrew

    echo ""
    read -p "Return to main menu? [y/n]: " return_menu
    if [[ "$return_menu" == "y" ]]; then
        show_menu
    else
        success "Dotfiles setup completed."
        exit 0
    fi
}

# Install apps and tools
install_apps() {
    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        warning "Homebrew is not installed. Installing prerequisites first..."
        install_xcode
        install_homebrew
    fi

    printf "\n"
    info "===================="
    info "Apps and Tools"
    info "===================="

    # Source the brew-install-custom.sh script if it exists
    if [ -f "$SCRIPT_DIR/scripts/brew-install-custom.sh" ]; then
        . $SCRIPT_DIR/scripts/brew-install-custom.sh
        install_custom_formulae
        install_custom_casks
        run_brew_bundle
    else
        error "brew-install-custom.sh script not found"
    fi

    echo ""
    read -p "Return to main menu? [y/n]: " return_menu
    if [[ "$return_menu" == "y" ]]; then
        show_menu
    else
        success "Dotfiles setup completed."
        exit 0
    fi
}

# Set up dotfiles
setup_dotfiles() {
    printf "\n"
    info "===================="
    info "Symbolic Links"
    info "===================="

    read -p "Overwrite existing dotfiles? [y/n] " overwrite_dotfiles

    chmod +x $SCRIPT_DIR/scripts/symlinks.sh
    if [[ "$overwrite_dotfiles" == "y" ]]; then
        warning "Deleting existing dotfiles..."
        $SCRIPT_DIR/scripts/symlinks.sh --delete --include-files
    fi
    $SCRIPT_DIR/scripts/symlinks.sh --create

    echo ""
    read -p "Return to main menu? [y/n]: " return_menu
    if [[ "$return_menu" == "y" ]]; then
        show_menu
    else
        success "Dotfiles setup completed."
        exit 0
    fi
}

# Install everything
install_all() {
    # Prerequisites
    printf "\n"
    info "===================="
    info "Prerequisites"
    info "===================="

    install_xcode
    install_homebrew

    # Apps and Tools
    printf "\n"
    info "===================="
    info "Apps and Tools"
    info "===================="

    if [ -f "$SCRIPT_DIR/scripts/brew-install-custom.sh" ]; then
        . $SCRIPT_DIR/scripts/brew-install-custom.sh
        install_custom_formulae
        install_custom_casks
        run_brew_bundle
    else
        error "brew-install-custom.sh script not found"
    fi

    # Dotfiles
    printf "\n"
    info "===================="
    info "Symbolic Links"
    info "===================="

    read -p "Overwrite existing dotfiles? [y/n] " overwrite_dotfiles

    chmod +x $SCRIPT_DIR/scripts/symlinks.sh
    if [[ "$overwrite_dotfiles" == "y" ]]; then
        warning "Deleting existing dotfiles..."
        $SCRIPT_DIR/scripts/symlinks.sh --delete --include-files
    fi
    $SCRIPT_DIR/scripts/symlinks.sh --create

    success "Dotfiles setup completed."
    exit 0
}

# Start the menu
show_menu
