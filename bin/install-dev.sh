#!/usr/bin/env bash

# this install file is subject to change
function green() { echo -ne "\033[0;32m$1\033[0m"; }
function cyan() { echo -ne "\033[1;36m$1\033[0m"; }
cd ~ || exit
if [ ! -d "$HOME/sh-touch" ]; then
  git clone https://github.com/sh-touch/sh-touch.git ~/sh-touch
fi
cd ~/sh-touch || exit && git checkout dev && cd ~ || exit

if [ ! -f "/usr/local/bin/sh-touch" ]; then
  ln -s ~/sh-touch/bin/sh-touch.sh /usr/local/bin/sh-touch
  echo -ne "$(green "command was installed, run it terminal using command: ")"
else
  echo -ne "$(green "command was existing and updated, run it in terminal using command: ")"
fi


echo -e "$(cyan "sh-touch")"