#!/bin/sh

# Install MacOS apps

source $HOME/dotfiles/log.sh

BrewCaskApps=(docker amazon-music iterm2 caffeine delayedlauncher alfred rectangle)

BrewApps=(
        'python3'
	'openssl'
	'tree'
	'wget'
        'awscli'
        'ruby'
        'git'

)

for app in ${BrewCaskApps[@]}; do
  if open -Ra "$app" ; then
    msg_done "$app installed outside of brew" 
  else
    if brew cask ls --versions $app  > /dev/null; then 
        msg_done $app
    else
        msg_run $app
        brew cask install $app 
    fi
  fi
done

for app in ${BrewApps[@]}; do
  if open -Ra "$app" ; then
    msg_done "$app installed outside of brew" 
  else
    if brew ls --versions $app  > /dev/null; then 
        msg_done $app
    else
        msg_run $app
        brew install $app 
    fi
  fi
done


