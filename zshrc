# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HYPHEN_INSENSITIVE="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo aws autopep8)

source $ZSH/oh-my-zsh.sh

# User configuration

# Syntax highlighting
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export "PATH=$HOME/.toolbox/bin:$PATH"

# Check for built-in adders
if [[ -d $HOME/dotfiles/dotfiles ]]; then
  for DOTFILE in `find $HOME/dotfiles/dotfiles`; do
    if [ -f "$DOTFILE" ]; then
      source "$DOTFILE"
    fi
  done
fi

# Check for custom adders
if [[ -d $HOME/dotfiles/custom ]]; then
  for DOTFILE in `find $HOME/dotfiles/custom`; do
    if [ -f "$DOTFILE" ]; then
      source "$DOTFILE"
    fi
  done
fi