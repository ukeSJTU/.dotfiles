#!/bin/bash
#
# Usage: symlinks.sh [OPTIONS]
#
# Options:
#   -h, --help     Show this help message and exit.
#   -f, --force    Force overwrite of conflicting files without prompt.
#   -d, --dry-run  Run in dry-run mode, showing what would be done.
#
# This script reads the configuration from symlinks.conf and creates the specified symbolic links.

set -e

# Display usage information
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help     Show this help message and exit.
  -f, --force    Force overwrite of conflicting files without prompt.
  -d, --dry-run  Run in dry-run mode, showing what would be done without making changes.

This script creates symbolic links as specified in symlinks.conf.
EOF
}

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
CONFIG_FILE="$SCRIPT_DIR/../symlinks.conf"

# Source utility functions (if available)
if [ -f "$(dirname "$0")/utils.sh" ]; then
    . "$(dirname "$0")/utils.sh"
else
    echo "Warning: utils.sh not found. Using fallback logging functions."
    info() { echo "[INFO] $1"; }
    warning() { echo "[WARNING] $1"; }
    error() { echo "[ERROR] $1"; }
    success() { echo "[SUCCESS] $1"; }
fi

# Check if configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

info "Reading configuration from $CONFIG_FILE"
info "Creating symbolic links..."

# Process each line in the configuration file
while IFS=: read -r source target || [ -n "$source" ]; do
    # Skip empty lines and comments
    if [[ -z "$source" || -z "$target" || "$source" =~ ^# ]]; then
        continue
    fi

    # Evaluate variables (support for environment variables, etc.)
    source=$(eval echo "$source")
    target=$(eval echo "$target")

    # Check if the source exists
    if [ ! -e "$source" ]; then
        error "Source file '$source' not found. Skipping link creation for '$target'."
        continue
    fi

    # If target already exists as a symlink, skip
    if [ -L "$target" ]; then
        warning "Symbolic link already exists: $target"
        continue
    fi

    # If target is a regular file
    if [ -f "$target" ]; then
        if cmp -s "$source" "$target"; then
            info "Target file '$target' is identical to the source. Skipping."
            continue
        else
            if [ "$FORCE" -eq 1 ]; then
                info "Force overwriting file: $target"
                if [ "$DRY_RUN" -eq 1 ]; then
                    echo "DRY RUN: cp -f '$source' '$target'"
                else
                    cp -f "$source" "$target"
                    success "Overwritten $target"
                fi
            else
                info "Target file '$target' exists and differs from source."
                read -p "Do you want to overwrite it? (y/n) or c to compare: " choice
                case "$choice" in
                y | Y)
                    if [ "$DRY_RUN" -eq 1 ]; then
                        echo "DRY RUN: cp -f '$source' '$target'"
                    else
                        cp -f "$source" "$target"
                        success "Overwritten $target"
                    fi
                    ;;
                c | C)
                    diff -u "$source" "$target"
                    read -p "Do you want to overwrite it after comparing? (y/n): " choice2
                    if [[ "$choice2" =~ ^[yY]$ ]]; then
                        if [ "$DRY_RUN" -eq 1 ]; then
                            echo "DRY RUN: cp -f '$source' '$target'"
                        else
                            cp -f "$source" "$target"
                            success "Overwritten $target"
                        fi
                    else
                        info "Skipped overwriting $target"
                    fi
                    ;;
                *)
                    info "Skipped overwriting $target"
                    ;;
                esac
            fi
            continue
        fi
    fi

    # If target is a directory, issue a warning and skip
    if [ -d "$target" ]; then
        warning "Target is a directory: $target. Skipping."
        continue
    fi

    # Create the target directory if it doesn't exist
    target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            echo "DRY RUN: mkdir -p '$target_dir'"
        else
            mkdir -p "$target_dir"
            info "Created directory: $target_dir"
        fi
    fi

    # Create the symbolic link
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "DRY RUN: ln -s '$source' '$target'"
    else
        ln -s "$source" "$target"
        success "Created symbolic link: $target"
    fi

done <"$CONFIG_FILE"
