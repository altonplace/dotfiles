#!/usr/bin/env bash

# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"
# shellcheck source=src/ui.sh
source "$HOME/dotfiles/ui.sh"

# Default Python packages
DEFAULT_PIP_PACKAGES=(
  'virtualenv'
  'requests'
  'gnupg'
  'pandas'
  'numpy'
)

# Check if a Python package is installed
is_package_installed() {
    local package="$1"
    python3 -m pip show "$package" &>/dev/null
}

# Install Python packages
install_pip_packages() {
    local packages=("$@")

    if [ ${#packages[@]} -eq 0 ]; then
        ui_info "No Python packages to install"
        return
    fi

    ui_step "Installing Python Packages"

    for package in "${packages[@]}"; do
        if is_package_installed "$package"; then
            ui_success "$package (already installed)"
        else
            ui_info "Installing $package..."
            if pip3 install "$package" --quiet; then
                ui_success "$package installed"
            else
                ui_error "Failed to install $package"
            fi
        fi
    done
}

# Main execution
main() {
    ui_header
    ui_step "Python Configuration"

    # Check if Python 3 is installed
    if ! command -v python3 &>/dev/null; then
        ui_info "Python 3 not found"
        if ui_confirm "Install Python 3 via Homebrew?" "y"; then
            ui_info "Installing Python 3..."
            brew install python3
            ui_success "Python 3 installed"
        else
            ui_error "Python 3 is required. Skipping Python package installation."
            return
        fi
    else
        ui_success "Python 3 is installed ($(python3 --version))"
    fi

    # Check if pip3 is installed
    if ! command -v pip3 &>/dev/null; then
        ui_error "pip3 not found. Please install Python 3 properly."
        return
    fi

    # Setup packages list
    pip_packages=("${DEFAULT_PIP_PACKAGES[@]}")

    ui_info "Default Python packages:"
    printf '  %s\n' "${pip_packages[@]}"
    echo ""

    if ui_confirm "Customize Python packages?" "n"; then
        readarray -t pip_packages < <(ui_edit_list "Python package" "${pip_packages[@]}")
    fi

    # Install packages
    if [ ${#pip_packages[@]} -gt 0 ]; then
        install_pip_packages "${pip_packages[@]}"
        ui_step "Python setup complete"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
