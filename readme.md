# .files

These are my dotfiles. Take anything you want, but at your own risk.

Primarily targets macOS systems (Ventura 13.0+), but should work on \*nix systems with `apt-get`.

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
- **Python Environment**
  - Python 3 with pip
  - Common packages: virtualenv, requests, gnupg, pandas, numpy
- **macOS Settings**
  - Trackpad, Finder, Dock, iTerm2 customizations

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

The bootstrap script will:
1. Install Homebrew (if not already installed)
2. Clone this repository to `~/dotfiles`
3. Prompt you to install applications via Homebrew
4. Prompt you to configure macOS settings
5. Prompt you to install Python packages
6. Prompt you to create dotfile symlinks
7. Switch to Zsh and install Oh-My-Zsh with Powerlevel10k

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

## Customization

- **Applications**: Edit the `BrewCaskApps` and `BrewApps` arrays in `apps.sh`
- **Dotfiles**: Modify files in the root directory (`zshrc`, `vimrc`, `p10k.zsh`)
- **macOS Settings**: Adjust preferences in `osx.sh`
- **Python Packages**: Update the `pip_packages` array in `python.sh`

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
├── bootstrap.sh       # Main installation script
├── apps.sh           # Homebrew package installation
├── osx.sh            # macOS system preferences
├── python.sh         # Python package installation
├── makesymlinks.sh   # Dotfile symlink creation
├── log.sh            # Logging utility functions
├── zshrc             # Zsh configuration
├── vimrc             # Vim configuration
└── p10k.zsh          # Powerlevel10k configuration
```

## License

These dotfiles are provided as-is. Feel free to use, modify, and distribute at your own risk.