#!/usr/bin/env bash

# this install file is subject to change
function green() { echo -ne "\033[0;32m$1\033[0m"; }
function cyan() { echo -ne "\033[1;36m$1\033[0m"; }
cd ~ || exit
if [ ! -d "$HOME/sh-touch" ]; then
  git clone https://github.com/sh-touch/sh-touch.git ~/sh-touch
fi
cd ~/sh-touch || exit && git checkout dev && cd ~ || exit

if [ ! -d "$HOME/sh-touch" ]; then
  ln -s ~/sh-touch/bin/sh-touch.sh /usr/local/bin/sh-touch
fi

echo -ne "$(green "script was installed,  run it terminal using command: ")"
echo -e "$(cyan "sh-touch")"