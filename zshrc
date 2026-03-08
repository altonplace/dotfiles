# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
path+=("$HOME/Library/Python/3.9/bin")

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
path+=("$HOME/.toolbox/bin")

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

# update path with all items added to the list
export PATH

# bun completions
[ -s "/Users/mike/.bun/_bun" ] && source "/Users/mike/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pai
alias pai='bun /Users/mike/.claude/skills/PAI/Tools/pai.ts'

# tmux: attach to dev session or create it
alias dev='tmux new-session -A -s dev'

# mang-teacher: log vim/tmux usage for mastery tracking (background — no latency)
_teacher_log() {
  local cmd="$1"
  bun run ~/.claude/skills/mang-teacher/Tools/log.ts --user mike --event "$cmd" </dev/null &>/dev/null 2>&1 &!
}

preexec() {
  local cmd="$1"
  # Match vim commands
  if [[ "$cmd" =~ ^(vim|nvim|vi)([[:space:]]|$) ]]; then
    _teacher_log "$cmd"
  fi
  # Match tmux subcommands (typed directly, not via keybinding)
  if [[ "$cmd" =~ ^tmux[[:space:]] ]]; then
    _teacher_log "$cmd"
  fi
}
set -a; source ~/.config/secrets/.env 2>/dev/null; set +a

# Fix: reset application cursor mode after each command.
# oh-my-zsh key-bindings.zsh calls echoti smkx in zle-line-init; p10k widget
# wrapping can break the paired rmkx call in zle-line-finish, leaving the
# terminal stuck in application cursor mode (arrows print raw escape sequences).
if (( ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function _reset_cursor_mode() { echoti rmkx }
  add-zle-hook-widget zle-line-finish _reset_cursor_mode
fi
