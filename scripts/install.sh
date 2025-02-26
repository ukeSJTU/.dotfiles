#!/bin/bash

. "$(dirname "$0")/utils.sh" # Load utility functions

INSTALL_CONFIG_FILE="$(dirname "$0")/../install.conf" # Path to configuration file

# Dry-run flag (set to true if --dry-run is passed)
DRY_RUN=false

# Function to simulate the installation process in dry-run mode
dry_run_install() {
    local tool=$1
    local method=$2
    info "Dry run: Would attempt to install $tool with method: $method"

    case "$method" in
    "brew")
        info "Dry run: brew install $tool"
        ;;
    "apt-get")
        info "Dry run: sudo apt-get install -y $tool"
        ;;
    "cargo")
        info "Dry run: cargo install $tool"
        ;;
    "custom")
        local custom_script="$SCRIPT_DIR/scripts/install/$tool.sh"
        if [ -f "$custom_script" ]; then
            info "Dry run: Executing custom script for $tool..."
        else
            error "Custom script for $tool not found in dry-run mode."
        fi
        ;;
    *)
        error "Unknown installation method: $method for $tool in dry-run mode"
        ;;
    esac
}

install_with_method() {
    local tool=$1
    local method=$2

    if [ "$DRY_RUN" = true ]; then
        dry_run_install "$tool" "$method"
    else
        info "Trying to install $tool with method: $method"

        case "$method" in
        "brew")
            if command -v brew &>/dev/null; then
                brew install "$tool" && success "$tool installed via brew"
            else
                warning "Homebrew not found. Skipping $tool installation with brew."
            fi
            ;;
        "apt-get")
            if command -v apt-get &>/dev/null; then
                sudo apt-get install -y "$tool" && success "$tool installed via apt-get"
            else
                warning "apt-get not found. Skipping $tool installation with apt-get."
            fi
            ;;
        "cargo")
            if command -v cargo &>/dev/null; then
                cargo install "$tool" && success "$tool installed via cargo"
            else
                warning "cargo not found. Skipping $tool installation with cargo."
            fi
            ;;
        "custom")
            # Check for custom installation script
            local custom_script="$SCRIPT_DIR/scripts/install/$tool.sh"
            if [ -f "$custom_script" ]; then
                info "Executing custom script for $tool..."
                bash "$custom_script" && success "$tool installed via custom script"
            else
                error "Custom installation script for $tool not found."
            fi
            ;;
        *)
            error "Unknown installation method: $method for $tool"
            ;;
        esac
    fi
}

install_tool() {
    local tool=$1
    local methods=$2
    local method
    for method in ${methods//,/ }; do
        install_with_method "$tool" "$method"
    done
}

install_apps() {
    # Read the configuration file and install apps
    while IFS='=' read -r tool methods || [ -n "$tool" ]; do
        if [[ ! "$tool" =~ ^# && -n "$tool" && -n "$methods" ]]; then
            install_tool "$tool" "$methods"
        fi
    done <"$INSTALL_CONFIG_FILE"
}

# Handle dry-run mode flag from setup.sh
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
fi

# Run the installation process
install_apps
