#!/bin/bash

. $(dirname "$0")/utils.sh

install_xcode() {
    info "Checking if Xcode command line tools are installed..."
    if ! xcode-select -p &>/dev/null; then
        info "Xcode command line tools not found. Installing..."
        xcode-select --install
    else
        success "Xcode command line tools are already installed."
    fi
}

install_homebrew() {
    info "Checking if Homebrew is installed..."
    if ! command -v brew &>/dev/null; then
        info "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        success "Homebrew is already installed."
    fi
}

install_cargo() {
    info "Checking if Cargo is installed..."
    if ! command -v cargo &>/dev/null; then
        info "Cargo not found. Installing..."
        /bin/bash -c "$(curl -sSf https://sh.rustup.rs)"
    else
        success "Cargo is already installed."
    fi
}

install_prerequisites() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_xcode
        install_homebrew
        install_cargo
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        install_homebrew
        install_cargo
    else
        error "Unsupported OS. Exiting."
        exit 1
    fi
}

dry_run() {
    info "Dry run enabled. No changes will be made."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        info "Detected macOS"
        info "Would install Xcode command line tools | Homebrew | Cargo"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        info "Detected Linux"
        info "Would install Homebrew | Cargo"
    else
        error "Unsupported OS. Exiting."
        exit 1
    fi
}

if [ "$1" == "--dry-run" ]; then
    dry_run
else
    install_prerequisites
fi
