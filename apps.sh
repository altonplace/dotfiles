#!/usr/bin/env bash

# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"


# -- Install/Update Cask Apps ------------------------------------------------------------------
BrewCaskApps=(docker iterm2 rectangle roon raspberry-pi-imager visual-studio-code)

msg_category "Installing Cask Applications"
for app in "${BrewCaskApps[@]}"; do
  if brew list --cask "$app" &>/dev/null; then
    msg_done "$app already installed"
  else
    msg_run "Installing $app..."
    if brew install --cask "$app"; then
      msg_done "$app installed successfully"
    else
      msg_run "Failed to install $app, skipping..."
    fi
  fi
done

# -- Install/Update Brew Apps ------------------------------------------------------------------
BrewApps=(openssl tree wget awscli ruby git)

msg_category "Installing Homebrew Packages"
for app in "${BrewApps[@]}"; do
  if brew list "$app" &>/dev/null; then
    msg_done "$app already installed"
  else
    msg_run "Installing $app..."
    if brew install "$app"; then
      msg_done "$app installed successfully"
    else
      msg_run "Failed to install $app, skipping..."
    fi
  fi
done

msg_done "Application installation complete"