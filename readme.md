# .files

These are my dotfiles. Take anything you want, but at your own risk.

Primarily targets macOS systems (Ventura 13.0+), but should work on \*nix systems with `apt-get`.

## ✨ New Interactive Features

This dotfiles setup now features an **enhanced interactive installation experience** inspired by Powerlevel10k:

- 🎨 **Beautiful UI** - Clean, colorful interface with clear prompts
- ✅ **Idempotent** - Safe to run multiple times without damage
- 🎯 **Customizable** - Interactively add/remove apps before installation
- 🔍 **Package Validation** - Validates Homebrew packages before attempting installation
- 🗑️ **Stock App Removal** - Optionally remove unwanted macOS stock apps (GarageBand, iMovie, etc.)
- 🔄 **Smart Detection** - Skips already-installed packages and configurations
- ⚙️ **Rectangle Auto-start** - Automatically adds Rectangle to login items

## What's Included

This dotfiles setup will install and configure:

- **Homebrew** - Package manager for macOS
- **Shell Environment**
  - Zsh with Oh-My-Zsh framework
  - Powerlevel10k prompt theme
  - Custom `.zshrc`, `.vimrc` configurations
- **Development Tools**
  - Git, Ruby, OpenSSL, wget, tree, AWS CLI
- **Applications** (via Homebrew Cask)
  - Docker, iTerm2, Rectangle, Roon, Raspberry Pi Imager, Visual Studio Code
  - *Fully customizable during installation*
- **Python Environment**
  - Python 3 with pip
  - Common packages: virtualenv, requests, gnupg, pandas, numpy
  - *Fully customizable during installation*
- **macOS Settings**
  - Trackpad tap-to-click
  - Finder customizations
  - Dock customizations (removes all default apps)
  - **Hot corners** (lower left = lock screen)
  - iTerm2 preferences
  - Rectangle added to login items

## Prerequisites

- macOS Ventura (13.0) or later recommended
- Administrator access (for `sudo` commands)
- Internet connection

## Installation

### Fresh macOS Installation

On a new macOS system, first install system updates and Xcode Command Line Tools:

```sh
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools include `git` and `make` (not available on stock macOS).

### Quick Install

Install this dotfiles setup with a single command:

```sh
curl -L https://raw.github.com/altonplace/dotfiles/master/bootstrap.sh | sh
```

The bootstrap script will interactively:
1. Check and install/update Homebrew
2. Check and install Git
3. Clone or update this repository to `~/dotfiles`
4. **Interactively customize** applications to install:
   - Show current list of Homebrew cask apps (GUI applications)
   - Show current list of Homebrew packages (CLI tools)
   - Allow you to add/remove items from each list
   - Validate new additions to ensure they exist
   - Show suggestions if package names are invalid
5. **Interactively customize** macOS settings:
   - Option to remove stock macOS apps (GarageBand, iMovie, Keynote, Numbers, Pages)
   - Customize which stock apps to remove
   - Configure system preferences (trackpad, dock, hot corners, etc.)
   - Automatically add Rectangle to login items
6. **Interactively customize** Python packages:
   - Show default Python packages
   - Allow you to add/remove packages
7. Configure dotfiles (create symlinks for `.zshrc`, `.vimrc`, `.p10k.zsh`)
8. Install Zsh, Oh-My-Zsh, and Powerlevel10k

All steps ask for confirmation before proceeding, and the script is **safe to run multiple times** - it will skip already-completed steps.

### Post-Installation

After the script completes and Zsh starts, configure the Powerlevel10k prompt:

```sh
p10k configure
```

## Manual Installation

If you prefer to run scripts individually:

```sh
# Clone the repository
git clone https://github.com/altonplace/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install applications
./apps.sh

# Configure macOS settings
./osx.sh

# Install Python packages
./python.sh

# Create dotfile symlinks
./makesymlinks.sh
```

## What Gets Modified

- **Dotfiles**: Existing dotfiles (`.zshrc`, `.vimrc`, `.p10k.zsh`) are backed up to `~/dotfiles_old`
- **Shell**: Default shell changed to Zsh (if not already)
- **macOS Settings**: System preferences for trackpad, dock, finder, and iTerm2
- **Homebrew**: Installs packages and applications if not present

## Troubleshooting

### Homebrew Installation Fails

If Homebrew installation fails, you may need to install it manually:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then re-run the bootstrap script.

### Xcode Command Line Tools Issues

Verify Xcode Command Line Tools are installed:

```sh
xcode-select -p
```

If not installed, run:

```sh
xcode-select --install
```

### Permission Errors

Some operations require administrator access. Ensure you run with `sudo` when prompted, or have sudo privileges configured for your user.

### Zsh Not Default Shell

If Zsh doesn't become the default shell:

```sh
chsh -s $(which zsh)
```

Then log out and log back in.

### Python Package Installation Fails

Ensure Python 3 and pip3 are installed:

```sh
python3 --version
pip3 --version
```

If missing, install via Homebrew:

```sh
brew install python3
```

## Interactive Customization

During installation, you can interactively customize:

- **Applications**: Add or remove Homebrew casks and packages
  - The script validates package names against Homebrew
  - Shows suggestions for similar packages if name is invalid
- **Stock macOS Apps**: Choose which built-in apps to remove
  - Default list: GarageBand, iMovie, Keynote, Numbers, Pages
  - Fully customizable during installation
- **Python Packages**: Add or remove Python packages
- **All major steps**: Confirm before each operation

## Manual Customization

You can also edit configuration files directly:

- **Applications**: Edit `DEFAULT_CASK_APPS` and `DEFAULT_BREW_APPS` in `apps.sh`
- **Dotfiles**: Modify files in the root directory (`zshrc`, `vimrc`, `p10k.zsh`)
- **macOS Settings**: Adjust preferences in `osx.sh`
- **Python Packages**: Update `DEFAULT_PIP_PACKAGES` in `python.sh`
- **Stock Apps to Remove**: Edit `DEFAULT_STOCK_APPS_TO_REMOVE` in `osx.sh`

## Uninstallation

To restore your original dotfiles:

```sh
# Restore backed up files
cd ~/dotfiles_old
cp .* ~/

# Change shell back (if desired)
chsh -s /bin/bash
```

## Repository Structure

```
dotfiles/
├── bootstrap.sh       # Main installation script (orchestrates everything)
├── ui.sh             # Interactive UI library (p10k-style menus)
├── log.sh            # Logging utility functions
├── apps.sh           # Homebrew package installation (interactive)
├── osx.sh            # macOS system preferences & stock app removal
├── python.sh         # Python package installation (interactive)
├── makesymlinks.sh   # Dotfile symlink creation
├── zshrc             # Zsh configuration
├── vimrc             # Vim configuration
└── p10k.zsh          # Powerlevel10k configuration
```

## Features

### 🎯 Idempotent Design

All scripts are designed to be **safe to run multiple times**:
- Existing installations are detected and skipped
- Already-installed packages are not reinstalled
- Existing symlinks are not recreated
- Git repository updates are optional
- No data loss on reruns

### 🎨 Interactive UI

The installation uses an interactive UI system inspired by `p10k configure`:
- Clear, colorful prompts
- Confirmation before each major step
- Easy-to-use menus for customization
- Success/error/warning indicators
- Progress feedback during operations

### ✅ Package Validation

When adding custom Homebrew packages:
- Validates package names against Homebrew's repository
- Shows similar packages if exact match not found
- Allows you to keep invalid names (with warning)
- Prevents installation failures from typos

### 🗑️ Stock App Removal

Optionally remove unwanted macOS stock applications:
- Default list includes: GarageBand, iMovie, Keynote, Numbers, Pages
- Fully customizable list
- Requires sudo access
- Confirms before permanent deletion
- Safe to run even if apps already removed

### ⚙️ macOS Customizations

- **Hot Corners**: Lower left corner = Lock Screen
- **Dock**: Removes all default apps
- **Trackpad**: Enables tap-to-click
- **iTerm2**: Disables quit confirmation
- **Rectangle**: Automatically added to login items

## License

These dotfiles are provided as-is. Feel free to use, modify, and distribute at your own risk.