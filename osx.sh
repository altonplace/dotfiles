#!/bin/sh
source $HOME/dotfiles/log.sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################



################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

msg_nested_lvl_done "[Accessories] Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40


###############################################################################
# Screen
###############################################################################

# Sleep the display after 60 minutes
sudo pmset -a displaysleep 60

# Set machine sleep to 60 minutes on battery
sudo pmset -b sleep 60

###############################################################################
# Finder
###############################################################################

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

# set screen lock on bottom left corner
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Dock & Mission Control
###############################################################################

# remove all apps from the dock
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others
killall Dock
msg_nested_lvl_done "[Dock] Removed all apps from the dock "


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
msg_done "osx customizations"
