#!/bin/bash
#
# Usage: setup.sh [OPTIONS]
#
# Options:
#   -h, --help       Show this help message and exit.
#   -f, --force      Force overwrite of conflicting files without prompt.
#   -d, --dry-run    Run in dry-run mode, showing what would be done.
#
# This script checks required dependencies and sets up symbolic links as defined in symlinks.conf.

# Display usage information
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help       Show this help message and exit.
  -f, --force      Force overwrite of conflicting files without prompt.
  -d, --dry-run    Run in dry-run mode, showing what would be done without making changes.

This script sets up symbolic links for dotfiles as defined in symlinks.conf.
It also checks for required applications.
EOF
}

# Default flags
FORCE=0
DRY_RUN=0

# Parse command line options
while [[ "$1" != "" ]]; do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    -f | --force)
        FORCE=1
        ;;
    -d | --dry-run)
        DRY_RUN=1
        ;;
    *)
        echo "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
    shift
done

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utility functions (if available)
if [ -f "$SCRIPT_DIR/scripts/utils.sh" ]; then
    . "$SCRIPT_DIR/scripts/utils.sh"
else
    echo "Warning: utils.sh not found. Falling back to basic logging."
    info() { echo "[INFO] $1"; }
    warning() { echo "[WARNING] $1"; }
    error() { echo "[ERROR] $1"; }
    success() { echo "[SUCCESS] $1"; }
fi

# List of required dependencies (adjust as needed)
dependencies=("starship" "tmux" "wezterm" "zsh")
info "Checking required applications..."
for dep in "${dependencies[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        warning "$dep is not installed. Please install $dep for proper functioning."
    else
        info "$dep is installed."
    fi
done

# Prepare arguments for the symlink script
SYMLINKS_ARGS=""
[ "$FORCE" -eq 1 ] && SYMLINKS_ARGS="$SYMLINKS_ARGS --force"
[ "$DRY_RUN" -eq 1 ] && SYMLINKS_ARGS="$SYMLINKS_ARGS --dry-run"

# Run the symlink setup
info "Setting up symbolic links..."
bash "$SCRIPT_DIR/scripts/symlinks.sh" $SYMLINKS_ARGS

if [ $? -eq 0 ]; then
    success "Setup completed successfully!"
else
    error "Setup encountered errors."
    exit 1
fi
