#!/usr/bin/env bash

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
          [Yy]* ) "$2"; break;;
          [Nn]* ) break;;
          * ) echo "Please answer y or n.";;
      esac
		yn=""
  done
}