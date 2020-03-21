#!/bin/sh


msg() { echo  "\033[0;37m$1\033[0m"; }
msg_ok() { echo  "\033[1;32m $1 \033[0m"; }
msg_prompt () { echo  "➜\033[1;37m $1 \033[0m"; }
msg_nested_done() { echo  "   * \033[0;37m $1 \033[0m"; }
msg_category() { echo  "   * \033[0;33m $1 \033[0m"; }
msg_nested_lvl_done() { echo  "       ➜ \033[0;37m $1 \033[0m"; }
msg_config() { echo  "➜ \033[1;36m $1 ✔\033[0m"; }
msg_run() { echo  "➜\033[1;35m $1  $2\033[0m"; }
msg_done() { echo  "✔ \033[1;37m $1 \033[0m"; }
show_art() { echo  "\033[1;37m $1 \033[0m"; }

check_and_do()  {
  while true; do
    msg_run "$1"
    read -p  "" yn
      case $yn in
          [Yy]* ) "$2"; break;;
          [Nn]* ) break;;
          * ) echo "Please answer y or n.";;
      esac
		yn=""
  done
}