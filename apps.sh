#!/usr/bin/env bash

# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"
# shellcheck source=src/ui.sh
source "$HOME/dotfiles/ui.sh"

# Default apps (can be customized by user)
DEFAULT_CASK_APPS=(docker iterm2 rectangle roon raspberry-pi-imager visual-studio-code)
DEFAULT_BREW_APPS=(openssl tree wget awscli ruby git)

# Validate if a brew package exists
validate_brew_package() {
    local package="$1"
    local is_cask="$2"

    if [[ "$is_cask" == "true" ]]; then
        if brew search --cask "/^${package}$/" &>/dev/null | grep -q "^${package}$"; then
            return 0
        fi
    else
        if brew search "/^${package}$/" &>/dev/null | grep -q "^${package}$"; then
            return 0
        fi
    fi

    # If exact match not found, show similar packages
    ui_warning "Package '$package' not found. Searching for similar packages..."

    if [[ "$is_cask" == "true" ]]; then
        local results=$(brew search --cask "$package" 2>/dev/null | head -5)
    else
        local results=$(brew search "$package" 2>/dev/null | head -5)
    fi

    if [[ -n "$results" ]]; then
        echo -e "${DIM}Similar packages:${RESET}"
        echo "$results"
    fi

    return 1
}

# Interactive app selection
customize_apps() {
    ui_header
    ui_step "Customize Applications"

    ui_info "Current Cask Applications (GUI apps):"
    printf '  %s\n' "${BrewCaskApps[@]}"
    echo ""

    if ui_confirm "Customize cask applications?" "n"; then
        readarray -t BrewCaskApps < <(ui_edit_list "cask app" "${BrewCaskApps[@]}")

        # Validate new additions
        ui_step "Validating cask applications..."
        local validated_apps=()
        for app in "${BrewCaskApps[@]}"; do
            if validate_brew_package "$app" "true"; then
                validated_apps+=("$app")
                ui_success "$app - valid"
            else
                if ui_confirm "Keep '$app' anyway? (installation may fail)" "n"; then
                    validated_apps+=("$app")
                fi
            fi
        done
        BrewCaskApps=("${validated_apps[@]}")
    fi

    echo ""
    ui_info "Current Homebrew Packages (CLI tools):"
    printf '  %s\n' "${BrewApps[@]}"
    echo ""

    if ui_confirm "Customize homebrew packages?" "n"; then
        readarray -t BrewApps < <(ui_edit_list "brew package" "${BrewApps[@]}")

        # Validate new additions
        ui_step "Validating homebrew packages..."
        local validated_apps=()
        for app in "${BrewApps[@]}"; do
            if validate_brew_package "$app" "false"; then
                validated_apps+=("$app")
                ui_success "$app - valid"
            else
                if ui_confirm "Keep '$app' anyway? (installation may fail)" "n"; then
                    validated_apps+=("$app")
                fi
            fi
        done
        BrewApps=("${validated_apps[@]}")
    fi
}

# Install cask applications
install_cask_apps() {
    if [ ${#BrewCaskApps[@]} -eq 0 ]; then
        ui_info "No cask applications to install"
        return
    fi

    ui_step "Installing Cask Applications"

    for app in "${BrewCaskApps[@]}"; do
        if brew list --cask "$app" &>/dev/null; then
            ui_success "$app (already installed)"
        else
            ui_info "Installing $app..."
            if brew install --cask "$app"; then
                ui_success "$app installed"
            else
                ui_error "Failed to install $app"
            fi
        fi
    done
}

# Install homebrew packages
install_brew_apps() {
    if [ ${#BrewApps[@]} -eq 0 ]; then
        ui_info "No homebrew packages to install"
        return
    fi

    ui_step "Installing Homebrew Packages"

    for app in "${BrewApps[@]}"; do
        if brew list "$app" &>/dev/null; then
            ui_success "$app (already installed)"
        else
            ui_info "Installing $app..."
            if brew install "$app"; then
                ui_success "$app installed"
            else
                ui_error "Failed to install $app"
            fi
        fi
    done
}

# Main execution
main() {
    # Use default apps
    BrewCaskApps=("${DEFAULT_CASK_APPS[@]}")
    BrewApps=("${DEFAULT_BREW_APPS[@]}")

    # Allow customization
    customize_apps

    # Install apps
    install_cask_apps
    install_brew_apps

    ui_step "Application installation complete"
}

# Run if executed directly, otherwise just define functions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi