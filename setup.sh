#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/scripts/utils.sh" # Source utility functions

# Default options
DRY_RUN=false
HELP=false
INSTALL_PREREQUISITES=false
INSTALL_APPS=false
CONFIGURE_SYMLINKS=false

# Functions for each phase
install_prerequisites() {
    info "Running prerequisites..."
    bash "$SCRIPT_DIR/scripts/prerequisites.sh"
}

install_apps() {
    info "Running app installations..."
    bash "$SCRIPT_DIR/scripts/install.sh"
}

configure_symlinks() {
    info "Setting up symbolic links..."
    bash "$SCRIPT_DIR/scripts/symlinks.sh" --create
}

dry_run() {
    info "Dry run enabled. No changes will be made."
    info "The following actions will be executed:"
    info "1. Install prerequisites"
    bash "$SCRIPT_DIR/scripts/prerequisites.sh" --dry-run
    info "2. Install apps"
    bash "$SCRIPT_DIR/scripts/install.sh" --dry-run
    info "3. Create symbolic links"
    bash "$SCRIPT_DIR/scripts/symlinks.sh" --dry-run
}

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -d, --dry-run               Show what will be done without making any changes"
    echo "  -h, --help                  Show this help message"
    echo "  -p, --install-prerequisites Run prerequisites installation (e.g., Homebrew)"
    echo "  -a, --install-apps          Install pre-configured apps"
    echo "  -s, --configure-symlinks    Create symlinks for dotfiles"
}

# Parse command-line arguments
while getopts "dhpas" opt; do
    case "$opt" in
    d | --dry-run)
        DRY_RUN=true
        ;;
    h | --help)
        HELP=true
        ;;
    p | --install-prerequisites)
        INSTALL_PREREQUISITES=true
        ;;
    a | --install-apps)
        INSTALL_APPS=true
        ;;
    s | --configure-symlinks)
        CONFIGURE_SYMLINKS=true
        ;;
    *)
        error "Invalid option: -$OPTARG"
        show_help
        exit 1
        ;;
    esac
done

# Show help if requested
if [ "$HELP" = true ]; then
    show_help
    exit 0
fi

# Dry run mode
if [ "$DRY_RUN" = true ]; then
    dry_run
    exit 0
fi

# Run each phase based on options
if [ "$INSTALL_PREREQUISITES" = true ] || [ -z "$INSTALL_PREREQUISITES" ]; then
    install_prerequisites
fi

if [ "$INSTALL_APPS" = true ] || [ -z "$INSTALL_APPS" ]; then
    install_apps
fi

if [ "$CONFIGURE_SYMLINKS" = true ] || [ -z "$CONFIGURE_SYMLINKS" ]; then
    configure_symlinks
fi

success "Setup completed successfully!"
echo $DRY_RUN
