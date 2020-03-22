#!/usr/bin/env bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

# shellcheck source=src/log.sh
source "$HOME/dotfiles/log.sh"

########## Variables

DIR=$HOME/dotfiles                    # dotfiles directory
OLDDIR=$HOME/dotfiles_old             # old dotfiles backup directory
files=("zshrc" "p10k.zsh" "vimrc")    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
msg_run "Creating $OLDDIR for backup of any existing dotfiles in ~"
mkdir -p "$OLDDIR"
msg_done "...done"

# change to the dotfiles directory
msg_run "Changing to the $DIR directory"
cd "$DIR" || exit
msg_done "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in "${files[@]}"; do
    msg_run "Moving any existing dotfiles from ~ to $OLDDIR"
    mv "$HOME/.$file" "$OLDDIR"
    msg_run "Creating symlink to $file in home directory."
    if [ -L "$HOME/.$file" ]; then
      rm "$HOME/.$file"
      ln -s "$DIR/$file" "$HOME/.$file"
    else
      ln -s "$DIR/$file" "$HOME/.$file"
    fi
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $DIR/oh-my-zsh/ ]]; then
        msg_run "cloning oh-my-zsh"
        git clone http://github.com/robbyrussell/oh-my-zsh.git        
    fi

    # Symlink the oh-my-zsh install
    mv ~/.oh-my-zsh/ "$OLDDIR"
    msg_run "Creating symlink to oh-my-zsh in home directory."
    ln -s "$DIR/oh-my-zsh/" "$HOME/.oh-my-zsh"

    # Set the default shell to zsh if it isn't currently set to zsh
    msg_run "Checking if zsh is default"
    if [[ ! $(echo "$SHELL") == $(command -v zsh) ]]; then
        msg_run "Changing shell to zsh."
        chsh -s "$(command -v zsh)"
    fi
    msg_done "Shell is zsh"

    # Install P10k Prompt
    msg_run "Install P10k..."
    if [[ ! -d $DIR/oh-my-zsh/themes/powerlevel10k ]]; then
	  git clone https://github.com/romkatv/powerlevel10k.git "$DIR/oh-my-zsh/themes/powerlevel10k";
	  else
    cd "$DIR/oh-my-zsh/themes/powerlevel10k" || exit
    git pull
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)

    elif [[ $platform == 'Darwin' ]]; then
        msg_run "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh
