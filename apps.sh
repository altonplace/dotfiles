#!/bin/bash

# Install MacOS apps

BrewCaskApps=(
	'docker'
        'amazon-music'
        'iterm2'
        'boostnote'
)

BrewApps=(
        'python3'
	'openssl'
	'tree'
	'wget'
        'awscli'
        'ruby'
        'git'

)

install_homebrew(){
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_brew_apps(){
  for app in BrewCaskApps; do
    brew cask install $app
  done
}

install_homebrew_cask(){
  brew tap caskroom/cask
}

install_brew_cask_apps(){
  for app in BrewApps; do
    brew install $app
  done
}
