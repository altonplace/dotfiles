#!/usr/bin/env bash

# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"

pip_packages=(
  'virtualenv'
  'requests'
  'gnupg'
  'pandas'
  'numpy'
)

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    msg_run "Python 3 not found, installing via Homebrew..."
    brew install python3
    msg_done "Python 3 installed"
fi

# Check if pip3 is installed
if ! command -v pip3 &> /dev/null; then
    msg_run "pip3 not found, please install Python 3 first"
    exit 1
fi

install_pip_packages(){
  for package in "${pip_packages[@]}"; do
    msg_run "Installing $package..."
    if pip3 install "$package"; then
        msg_done "$package installed successfully"
    else
        msg_run "Failed to install $package, continuing..."
    fi
  done
}

install_pip_packages
msg_done "Python packages installation complete"
