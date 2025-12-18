#!/usr/bin/env bash

# Tells the shell script to exit if it encounters an error
set -e

# -- Functions -----------------------------------------------------------------------
# Duplicated code from log.sh and ui.sh
# since we cannot import files when installing via cURL

# Basic logging functions
msg() { echo -e "\x1B[0;37m$1\x1B[0m"; }
msg_done() { echo -e "✔ \x1B[1;37m $1 \x1B[0m"; }
msg_run() { echo -e "➜\x1B[1;35m $1\x1B[0m"; }
show_art() { echo -e "\x1B[1;37m $1 \x1B[0m"; }

# UI functions (simplified versions for bootstrap)
ui_confirm() {
    local question="$1"
    local default="${2:-y}"

    echo ""
    echo -e "\x1B[1m\x1B[34m$question\x1B[0m"

    while true; do
        if [[ "$default" == "y" ]]; then
            read -r -p "[Y/n] > " yn
            yn=${yn:-y}
        else
            read -r -p "[y/N] > " yn
            yn=${yn:-n}
        fi

        case "$yn" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer y or n" ;;
        esac
    done
}

ui_step() {
    echo ""
    echo -e "\x1B[1m\x1B[32m➜\x1B[0m \x1B[1m$1\x1B[0m"
}

ui_info() {
    echo -e "\x1B[36mℹ\x1B[0m $1"
}

ui_success() {
    echo -e "\x1B[32m✓\x1B[0m $1"
}

ui_error() {
    echo -e "\x1B[31m✗\x1B[0m $1"
}

# -- Init -----------------------------------------------------------------------

show_header() {
    clear
    echo ""
    show_art "╔════════════════════════════════════════════════════════════════════╗"
    show_art "║                                                                    ║"
    show_art "║                    .::            .::      .::    .::              ║"
    show_art "║                    .::            .::    .:    .: .::              ║"
    show_art "║                    .::   .::    .:.: .:.:.: .:    .::   .::       ║"
    show_art "║                .:: .:: .::  .::   .::    .::  .:: .:: .:   .::    ║"
    show_art "║               .:   .::.::    .::  .::    .::  .:: .::.::::: .::   ║"
    show_art "║               .:   .:: .::  .::   .::    .::  .:: .::.:            ║"
    show_art "║               .:: .::   .::       .::   .::  .::.:::  .::::        ║"
    show_art "║                                                                    ║"
    show_art "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
    msg_done 'Dotfiles Setup - Enhanced Interactive Installation'
    echo ""
}

show_header

# -- Homebrew Installation -----------------------------------------------------
install_homebrew() {
    ui_step "Checking Homebrew Installation"

    if hash brew 2>/dev/null; then
        ui_success "Homebrew already installed"
        # Update homebrew
        if ui_confirm "Update Homebrew?" "y"; then
            ui_info "Updating Homebrew..."
            brew update
            ui_success "Homebrew updated"
        fi
    else
        ui_info "Homebrew not installed"
        if ui_confirm "Install Homebrew now?" "y"; then
            ui_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            ui_success "Homebrew installed successfully"
        else
            ui_error "Homebrew is required for this setup. Exiting."
            exit 1
        fi
    fi
}

# -- Git Installation ----------------------------------------------------------
install_git() {
    ui_step "Checking Git Installation"

    if hash git 2>/dev/null; then
        ui_success "Git already installed"
    else
        ui_info "Git not installed"
        if ui_confirm "Install Git via Homebrew?" "y"; then
            brew install git
            ui_success "Git installed"
        else
            ui_error "Git is required for this setup. Exiting."
            exit 1
        fi
    fi
}

# -- Dotfiles Repository -------------------------------------------------------
setup_dotfiles_repo() {
    ui_step "Setting Up Dotfiles Repository"

    DIR=$HOME/dotfiles

    if [ -d "$DIR/.git" ]; then
        ui_success "Dotfiles repository already exists"
        if ui_confirm "Pull latest changes from GitHub?" "y"; then
            cd "$DIR" || exit
            ui_info "Pulling latest changes..."
            if git pull; then
                ui_success "Repository updated"
            else
                ui_error "Failed to pull changes (continuing anyway)"
            fi
        fi
    else
        if [ -d "$DIR" ]; then
            ui_info "Directory exists but is not a git repository"
            if ui_confirm "Remove existing directory and clone fresh?" "n"; then
                rm -rf "$DIR"
            else
                ui_error "Cannot proceed without a clean dotfiles directory. Exiting."
                exit 1
            fi
        fi

        ui_info "Cloning dotfiles repository..."
        if git clone https://github.com/altonplace/dotfiles.git "$DIR"; then
            ui_success "Dotfiles repository cloned"
        else
            ui_error "Failed to clone repository. Exiting."
            exit 1
        fi
    fi

    # Export DIR for use by other scripts
    export DOTFILES_DIR="$DIR"
}

# -- Main Setup Steps ----------------------------------------------------------

install_homebrew
install_git
setup_dotfiles_repo

# Change to dotfiles directory
cd "$HOME/dotfiles" || exit

# Now we can source the full libraries
# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"
# shellcheck source=src/ui.sh
source "$HOME/dotfiles/ui.sh"

# -- Apps Installation ---------------------------------------------------------
if ui_confirm "Install applications with Homebrew?" "y"; then
    source "$HOME/dotfiles/apps.sh"
    main
fi

# -- macOS Configuration -------------------------------------------------------
if ui_confirm "Configure macOS settings?" "y"; then
    source "$HOME/dotfiles/osx.sh"
    main
fi

# -- Python Setup --------------------------------------------------------------
if ui_confirm "Install Python and packages?" "y"; then
    source "$HOME/dotfiles/python.sh"
    main
fi

# -- Dotfiles Configuration ----------------------------------------------------
if ui_confirm "Configure dotfiles (create symlinks)?" "y"; then
    source "$HOME/dotfiles/makesymlinks.sh"
    # The makesymlinks.sh will call install_zsh automatically
fi

# -- Completion ----------------------------------------------------------------
ui_step "Setup Complete!"
ui_success "Your machine is configured! 🎉"
echo ""
ui_info "Note: After zsh starts, run 'p10k configure' to customize your prompt"
echo ""

if ui_confirm "Start zsh now?" "y"; then
    exec zsh
else
    ui_info "You can start zsh later by running: exec zsh"
fi
