#!/bin/bash

default_color=$(tput sgr 0)
red="$(tput setaf 1)"
yellow="$(tput setaf 3)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"

info() {
    printf "%s==> %s%s\n" "$blue" "$1" "$default_color"
}

success() {
    printf "%s==> %s%s\n" "$green" "$1" "$default_color"
}

error() {
    printf "%s==> %s%s\n" "$red" "$1" "$default_color"
}

warning() {
    printf "%s==> %s%s\n" "$yellow" "$1" "$default_color"
}

log() {
    # Logs messages to a file with timestamp
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >>"$LOG_FILE"
}

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M-%S)

# Optionally handle redirection for logs
LOG_FILE="${HOME}/.dotfiles/.logs/setup-${DATE}-${TIME}.log"
# echo $LOG_FILE
