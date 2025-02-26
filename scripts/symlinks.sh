#!/bin/bash

# Get the absolute path of the directory where the script is located
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$(dirname "$0")/../symlinks.conf"

# . "$SCRIPT_DIR/utils.sh" # Source utility functions

. $(dirname "$0")/utils.sh

# Check if configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Create symbolic links
create_symlinks() {
    info "Creating symbolic links..."

    # Read dotfile links from the config file
    while IFS=: read -r source target || [ -n "$source" ]; do
        # Skip empty or invalid lines
        if [[ -z "$source" || -z "$target" || "$source" == \#* ]]; then
            continue
        fi

        # Evaluate variables (support for environment variables, etc.)
        source=$(eval echo "$source")
        target=$(eval echo "$target")

        # Check if the source file exists
        if [ ! -e "$source" ]; then
            error "Source file '$source' not found. Skipping link creation for '$target'."
            continue
        fi

        # Check if the target is a symlink and skip if it already exists
        if [ -L "$target" ]; then
            warning "Symbolic link already exists: $target"
        elif [ -f "$target" ]; then
            # If target file exists, check for file content differences
            if cmp -s "$source" "$target"; then
                info "Target file '$target' is identical to the source. Skipping."
            else
                # Prompt user for action if the content differs
                info "Target file '$target' exists and differs from source."
                read -p "Do you want to overwrite it? (y/n) or c to compare: " choice
                case "$choice" in
                y | Y)
                    # Overwrite the file
                    cp -f "$source" "$target"
                    success "Overwritten $target"
                    ;;
                c | C)
                    # Show file differences
                    diff -u "$source" "$target"
                    read -p "Do you want to overwrite it after seeing the difference? (y/n): " choice2
                    if [[ "$choice2" =~ ^[yY]$ ]]; then
                        cp -f "$source" "$target"
                        success "Overwritten $target"
                    else
                        info "Skipped overwriting $target"
                    fi
                    ;;
                *)
                    info "Skipped overwriting $target"
                    ;;
                esac
            fi
        elif [ -d "$target" ]; then
            warning "Target is a directory: $target"
        else
            # Create the directory if it doesn't exist
            target_dir=$(dirname "$target")
            if [ ! -d "$target_dir" ]; then
                mkdir -p "$target_dir"
                info "Created directory: $target_dir"
            fi

            # Create the symbolic link
            ln -s "$source" "$target"
            success "Created symbolic link: $target"
        fi
    done <"$CONFIG_FILE"
}

# Delete symbolic links or files
delete_symlinks() {
    info "Deleting symbolic links..."

    while IFS=: read -r _ target || [ -n "$target" ]; do
        if [[ -z "$target" ]]; then
            continue
        fi

        # Evaluate the target path
        target=$(eval echo "$target")

        # Check if the symbolic link or file exists
        if [ -L "$target" ] || { [ "$include_files" == true ] && [ -f "$target" ]; }; then
            rm -rf "$target"
            success "Deleted: $target"
        else
            warning "Not found: $target"
        fi
    done <"$CONFIG_FILE"
}

# Dry run mode (simulated actions without making any changes)
dry_run() {
    info "Dry run mode: No changes will be made."
    info "The following actions will be executed:"
    while IFS=: read -r source target || [ -n "$source" ]; do
        if [[ -z "$source" || -z "$target" || "$source" == \#* ]]; then
            continue
        fi

        source=$(eval echo "$source")
        target=$(eval echo "$target")
        info "Create symlink: $source -> $target"
    done <"$CONFIG_FILE"
}

# If called from setup.sh, execute the create_symlinks function
if [ "$1" == "--create" ]; then
    create_symlinks
elif [ "$1" == "--delete" ]; then
    delete_symlinks
elif [ "$1" == "--dry-run" ]; then
    dry_run
fi
