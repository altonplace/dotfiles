# .files

These are my dotfiles. Take anything you want, but at your own risk.

It targets macOS systems, but it should work on \*nix as well (with `apt-get`).

## Package overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [homebrew-cask](https://caskroom.github.io) (packages: [Caskfile](./install/Caskfile))
- Latest Git, Bash 4, Python 3, GNU coreutils, curl

## Install

On a sparkling fresh installation of macOS:

```sh
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).
Then, install this repo with `curl` available:
    
```sh
curl -L https://raw.github.com/vsouza/dotfiles/master/bootstrap.sh | sh
```
