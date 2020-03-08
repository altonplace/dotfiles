#!/bin/sh
source $HOME/dotfiles/log.sh



sudo -v

###############################################################################
# General UI/UX
###############################################################################


################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

# msg_nested_lvl_done "[Accessories] Trackpad: enable tap to click for this user and for the login screen"
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  

###############################################################################
# Screen
###############################################################################


###############################################################################
# Finder
###############################################################################



###############################################################################
# Dock & Mission Control
###############################################################################



###############################################################################
# Time Machine
###############################################################################



###############################################################################
# Iterm2
###############################################################################

# Don’t display the annoying prompt when quitting iTerm
msg_nested_lvl_done "[iterm2] Disable iterm2 quit prompt"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Kill affected applications
############################"Terminal" "Transmission"; do
killall "${app}" > /dev/null 2>&1
msg_done "osx customizations"
