#!/usr/bin/sh

# Tells the shell script to exit if it encounters an error
set -e

# -- Functions -----------------------------------------------------------------------
# Duplicated code from log.sh
# since we cannot import a file when installing via cURL
msg() { echo -e  "\x1B[0;37m$1\x1B[0m"; }
msg_ok() { echo -e  "\x1B[1;32m $1 \x1B[0m"; }
msg_prompt () { echo -e  "➜\x1B[1;37m $1 \x1B[0m"; }
msg_nested_done() { echo -e  "   * \x1B[0;37m $1 \x1B[0m"; }
msg_category() { echo -e  "   * \x1B[0;33m $1 \x1B[0m"; }
msg_nested_lvl_done() { echo -e  "       ➜ \x1B[0;37m $1 \x1B[0m"; }
msg_config() { echo -e  "➜ \x1B[1;36m $1 ✔\x1B[0m"; }
msg_run() { echo -e  "➜\x1B[1;35m $1  $2\x1B[0m"; }
msg_done() { echo -e "✔ \x1B[1;37m $1 \x1B[0m"; }
show_art() { echo -e "\x1B[1;37m $1 \x1B[0m"; }

check_and_do()  {
  while true; do
    msg_run "$1"
    read -p  "" yn
      case $yn in
          [Yy]* ) $2; break;;
          [Nn]* ) break;;
          * ) echo "Please answer y or n.";;
      esac
		yn=""
  done
}

# -- Init -----------------------------------------------------------------------

msg '\n'

show_art "     .::            .::      .::    .::                 "
show_art "     .::            .::    .:    .: .::                 "
show_art "     .::   .::    .:.: .:.:.: .:    .::   .::     .:::: "
show_art " .:: .:: .::  .::   .::    .::  .:: .:: .:   .:: .::    "
show_art ".:   .::.::    .::  .::    .::  .:: .::.::::: .::  .::: "
show_art ".:   .:: .::  .::   .::    .::  .:: .::.:            .::"
show_art ".:: .::   .::       .::   .::  .::.:::  .::::   .:: .:: "


msg '\n'
msg_done 'Initializing setup.'
msg '\n'

# -- Homebrew ------------------------------------------------------------------
if hash brew 2> /dev/null; then
	msg_done "Hombrew already installed"
else
	msg_prompt "Homebrew not installed....installing..."
	msg_run "homebrew" "ruby -e '$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)'"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# -- Git -----------------------------------------------------------------------
if hash git 2> /dev/null; then
	msg_done "git already installed"
else
	msg_run "git not installed....installing..."
	brew install git 2> /dev/null
fi


# -- Dotfiles ------------------------------------------------------------------
DIR=~/dotfiles
if [ -d $DIR ]; then
	cd $DIR || exit
	git pull > /dev/null
	msg_done "Pulled latest dotfiles from Github"

else
	msg "dotfiles" "git clone https://github.com/altonplace/dotfiles.git ~/dotfiles"
	git clone https://github.com/altonplace/dotfiles.git ~/dotfiles
	msg_done "Cloned dotfiles from Github"
fi
#DIR=. # Uncomment to use the local version of the scripts

# -- Apps ------------------------------------------------------------------
check_and_do "Install apps with homebrew cask? [y/n]" "$DIR/apps.sh"

# -- OSX ------------------------------------------------------------------

check_and_do "Configure OSX? [y/n]" "$DIR/osx.sh"

# -- Python ------------------------------------------------------------------

check_and_do "Install and Configure Python? [y/n]" "$HOME/dotfiles/python.sh"

# -- Configure Dotfiles ------------------------------------------------------------------

check_and_do "Configure dotfiles? [y/n]" "$DIR/makesymlinks.sh"

# -- Configure P10K ------------------------------------------------------------------

check_and_do "Configure P10K? [y/n]" p10k configure

# -- Close ------------------------------------------------------------------

msg_done "Your machine  works like a charm! =*"
