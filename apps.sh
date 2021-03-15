#!/usr/bin/env bash

# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"


# -- Install/Update Cask Apps ------------------------------------------------------------------
BrewCaskApps=(docker iterm2 alfred rectangle)

for app in "${BrewCaskApps[@]}"; do
  if open -Ra "$app" 2> /dev/null; then
    msg_done "$app"
  else
    if brew cask ls --versions "$app"  > /dev/null; then
        msg_done "$app"
    else
        msg_run "$app"
        brew cask install "$app"
        msg_done "$app"
    fi
  fi
done

# -- Install/Update Brew Apps ------------------------------------------------------------------
BrewApps=(openssl tree wget awscli ruby git)

for app in "${BrewApps[@]}"; do
  if open -Ra "$app" 2> /dev/null; then
    msg_done "$app installed outside of brew"
  else
    if brew ls --versions "$app"  > /dev/null; then 
        msg_done "$app"
    else
        msg_run "$app"
        brew install "$app" 
    fi
  fi
done