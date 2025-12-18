#!/usr/bin/env bash

# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"
# shellcheck source=src/ui.sh
source "$HOME/dotfiles/ui.sh"

# Default stock macOS apps that can be removed (user can customize)
DEFAULT_STOCK_APPS_TO_REMOVE=(
    "GarageBand"
    "iMovie"
    "Keynote"
    "Numbers"
    "Pages"
)

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
close_system_preferences() {
    osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
    osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
}

close_system_preferences

sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
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

# set lock screen on bottom left corner (hot corner)
defaults write com.apple.dock wvous-bl-corner -int 13
defaults write com.apple.dock wvous-bl-modifier -int 0
msg_nested_lvl_done "[Hot Corners] Lower left corner set to Lock Screen"

###############################################################################
# Dock & Mission Control
###############################################################################

# remove all apps from the dock
defaults delete com.apple.dock persistent-apps 2>/dev/null || true
defaults delete com.apple.dock persistent-others 2>/dev/null || true
killall Dock 2>/dev/null || true
msg_nested_lvl_done "[Dock] Removed all apps from the dock"


###############################################################################
# Time Machine
###############################################################################



###############################################################################
# Iterm2
###############################################################################

# Don't display the annoying prompt when quitting iTerm
msg_nested_lvl_done "[iterm2] Disable iterm2 quit prompt"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Login Items
###############################################################################

# Add Rectangle to login items if installed
add_rectangle_to_login_items() {
    if [ -d "/Applications/Rectangle.app" ]; then
        # Check if already in login items
        if ! osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null | grep -q "Rectangle"; then
            osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Rectangle.app", hidden:false}' 2>/dev/null
            msg_nested_lvl_done "[Login Items] Rectangle added to login items"
        else
            msg_nested_lvl_done "[Login Items] Rectangle already in login items"
        fi
    fi
}

add_rectangle_to_login_items

###############################################################################
# Stock macOS Apps Removal
###############################################################################

# Remove stock macOS apps (if user chooses)
remove_stock_apps() {
    local apps_to_remove=("$@")

    if [ ${#apps_to_remove[@]} -eq 0 ]; then
        ui_info "No stock apps selected for removal"
        return
    fi

    ui_step "Removing Stock macOS Apps"
    ui_warning "This requires sudo access and will permanently remove these apps"

    for app in "${apps_to_remove[@]}"; do
        local app_path="/Applications/${app}.app"

        if [ -d "$app_path" ]; then
            ui_info "Removing $app..."
            if sudo rm -rf "$app_path"; then
                ui_success "$app removed"
            else
                ui_error "Failed to remove $app"
            fi
        else
            ui_info "$app not found (may already be removed)"
        fi
    done
}

###############################################################################

# Main execution with interactive stock app removal
main() {
    ui_header
    ui_step "macOS Configuration"

    # Ask about stock app removal
    echo ""
    if ui_confirm "Remove stock macOS apps? (GarageBand, iMovie, etc.)" "n"; then
        StockAppsToRemove=("${DEFAULT_STOCK_APPS_TO_REMOVE[@]}")

        ui_info "Default apps to remove:"
        printf '  %s\n' "${StockAppsToRemove[@]}"
        echo ""

        if ui_confirm "Customize the list of stock apps to remove?" "n"; then
            readarray -t StockAppsToRemove < <(ui_edit_list "stock app" "${StockAppsToRemove[@]}")
        fi

        # Confirm before removal
        if [ ${#StockAppsToRemove[@]} -gt 0 ]; then
            echo ""
            ui_warning "The following apps will be permanently removed:"
            printf '  %s\n' "${StockAppsToRemove[@]}"
            echo ""

            if ui_confirm "Proceed with removal?" "n"; then
                remove_stock_apps "${StockAppsToRemove[@]}"
            fi
        fi
    fi

    msg_done "osx customizations complete"
}

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
