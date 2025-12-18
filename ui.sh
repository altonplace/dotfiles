#!/usr/bin/env bash

# Interactive UI functions inspired by p10k configure

# Colors and formatting
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'

# Clear screen and show header
ui_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                    Dotfiles Configuration                          ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# Show a question with Yes/No options
# Usage: ui_confirm "Question?" && do_something
ui_confirm() {
    local question="$1"
    local default="${2:-y}" # default to yes

    echo ""
    echo -e "${BOLD}${BLUE}$question${RESET}"
    echo ""

    while true; do
        if [[ "$default" == "y" ]]; then
            echo -e "${DIM}(y) Yes  (n) No  [Y/n]${RESET}"
            read -r -p "> " yn
            yn=${yn:-y}
        else
            echo -e "${DIM}(y) Yes  (n) No  [y/N]${RESET}"
            read -r -p "> " yn
            yn=${yn:-n}
        fi

        case "$yn" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo -e "${RED}Please answer y or n${RESET}" ;;
        esac
    done
}

# Show a menu with numbered options
# Usage: ui_menu "Choose:" "Option 1" "Option 2" "Option 3"
# Returns: Selected index (0-based)
ui_menu() {
    local prompt="$1"
    shift
    local options=("$@")

    echo ""
    echo -e "${BOLD}${BLUE}$prompt${RESET}"
    echo ""

    for i in "${!options[@]}"; do
        echo -e "${DIM}($((i+1)))${RESET} ${options[$i]}"
    done
    echo ""

    while true; do
        read -r -p "> " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
            return $((choice - 1))
        else
            echo -e "${RED}Invalid choice. Please enter a number between 1 and ${#options[@]}${RESET}"
        fi
    done
}

# Show a step message
ui_step() {
    echo ""
    echo -e "${BOLD}${GREEN}➜${RESET} ${BOLD}$1${RESET}"
    echo ""
}

# Show an info message
ui_info() {
    echo -e "${CYAN}ℹ${RESET} $1"
}

# Show a success message
ui_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

# Show an error message
ui_error() {
    echo -e "${RED}✗${RESET} $1"
}

# Show a warning message
ui_warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

# Edit a list interactively
# Usage: ui_edit_list "App name (singular)" "${array[@]}"
# Returns: Modified array via stdout (one item per line)
ui_edit_list() {
    local item_name="$1"
    shift
    local items=("$@")

    while true; do
        echo ""
        echo -e "${BOLD}Current ${item_name}s:${RESET}"
        echo ""

        if [ ${#items[@]} -eq 0 ]; then
            echo -e "${DIM}  (none)${RESET}"
        else
            for i in "${!items[@]}"; do
                echo -e "  ${DIM}$((i+1)).${RESET} ${items[$i]}"
            done
        fi

        echo ""
        echo -e "${DIM}Options:${RESET}"
        echo -e "  ${DIM}(a)${RESET} Add $item_name"
        echo -e "  ${DIM}(r)${RESET} Remove $item_name"
        echo -e "  ${DIM}(d)${RESET} Done"
        echo ""

        read -r -p "> " action

        case "$action" in
            [Aa])
                read -r -p "Enter $item_name to add: " new_item
                if [[ -n "$new_item" ]]; then
                    items+=("$new_item")
                    ui_success "Added: $new_item"
                fi
                ;;
            [Rr])
                if [ ${#items[@]} -eq 0 ]; then
                    ui_warning "No items to remove"
                else
                    read -r -p "Enter number to remove: " num
                    if [[ "$num" =~ ^[0-9]+$ ]] && ((num >= 1 && num <= ${#items[@]})); then
                        removed="${items[$((num-1))]}"
                        unset 'items[$((num-1))]'
                        items=("${items[@]}") # Re-index array
                        ui_success "Removed: $removed"
                    else
                        ui_error "Invalid number"
                    fi
                fi
                ;;
            [Dd])
                break
                ;;
            *)
                ui_error "Invalid option"
                ;;
        esac
    done

    # Output the final list
    printf '%s\n' "${items[@]}"
}

# Wait for user to press enter
ui_pause() {
    echo ""
    read -r -p "Press Enter to continue..."
}
