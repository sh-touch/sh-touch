#!/bin/bash

clear

green="\033[0;32m"
cyan="\033[0;36m"
esc="\033[0m"

function wrapColor() { echo -ne "\033[$1m$2\033[0m"; }
function wrapColorBold() { echo -ne "\033[1;$1m$2\033[0m"; }
function c() { echo -ne "\033[0;36m$1\033[0m  │"; }
function e() { echo -ne "\033[0;36m$1\033[0m│"; }

function colorEffectFore_() { echo -ne "\033[0;36mFG Color > Effect\033[0m  "; }
function colorEffectBack_() { echo -ne "\033[0;36mBG Color > Effect\033[0m  "; }
function effect0() { echo -ne "${cyan}Normal ${esc}   "; }
function effect1() { echo -ne "${cyan}Bold ${esc}     "; }
function effect2() { echo -ne "${cyan}Dimmed ${esc}   "; }
function effect3() { echo -ne "${cyan}Italic ${esc}   "; }
function effect4() { echo -ne "${cyan}Underline${esc} "; }
function effect5() { echo -ne "${cyan}RapidBlink${esc}"; }
function effect6() { echo -ne "${cyan}SlowBlink${esc} "; }
function effect7() { echo -ne "${cyan}Reverse${esc}   "; }
function effect8() { echo -ne "${cyan}Hide${esc}      "; }
function effect9() { echo -ne "${cyan}Strike${esc}    "; }
function effect10() { echo -ne "${cyan}Primary${esc}    "; }

echo -e "$(wrapColorBold 32 "ANSI Color > Effect matrix")
© Copyright 2020-$currentYear $(wrapColor 36 biesior.com)"

table_____Top="┌────────────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬─────────────┐"
samplePattern="│ Foreground Cyan    │ \033[0;36m │ \033[1;36m │ \033[2;36m │ \033[3;36m │ \033[4;36m │ \033[5;36m │ \033[6;36m │ \033[7;36m │ \033[8;36m │ \033[9;36m │ \033[10;36m │"
head___Bottom="├────────────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼─────────────┤"
table_MidFore="│ $(colorEffectFore_)│ $(effect0) │ $(effect1) │ $(effect2) │ $(effect3) │ $(effect4) │ $(effect5) │ $(effect6) │ $(effect7) │ $(effect8) │ $(effect9) │ $(effect10) │"
table_MidBack="│ $(colorEffectBack_)│ $(effect0) │ $(effect1) │ $(effect2) │ $(effect3) │ $(effect4) │ $(effect5) │ $(effect6) │ $(effect7) │ $(effect8) │ $(effect9) │ $(effect10) │"
table__Bottom="└────────────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴─────────────┘"

function basicForeColors() {
  echo -ne "
$table_____Top
$table_MidFore
$head___Bottom
"

  for colorSubset in {30..37}; do
    case $colorSubset in
    30) colorName="Black  " ;;
    31) colorName="Red    " ;;
    32) colorName="Green  " ;;
    33) colorName="Yellow " ;;
    34) colorName="Blue   " ;;
    35) colorName="Magenta" ;;
    36) colorName="Cyan   " ;;
    37) colorName="White  " ;;
    *) colorName="Unknown FG color  " ;;
    esac
    echo -ne "│ $colorSubset $(wrapColor "$colorSubset" " $colorName       ") │ "
    for style in {0..10}; do
      tag="\033[${style};${colorSubset}m"
      label="\\\033[${style};${colorSubset}m"

      echo -ne "${tag}${label}${esc} │ "
    done
    echo
  done
  echo -ne "$table__Bottom $esc"
}

function basicBackColors() {
  echo -ne "
$table_____Top
$table_MidBack
$head___Bottom
"

  for colorSubset in {40..47}; do
    case $colorSubset in
    40) colorName="Black  " ;;
    41) colorName="Red    " ;;
    42) colorName="Green  " ;;
    43) colorName="Yellow " ;;
    44) colorName="Blue   " ;;
    45) colorName="Magenta" ;;
    46) colorName="Cyan   " ;;
    47) colorName="White  " ;;
    *) colorName="Unknown FG color  " ;;
    esac
    echo -ne "│ $colorSubset $(wrapColor "$colorSubset" " $colorName ")       │ "
    for style in {0..10}; do
      tag="\033[${style};${colorSubset}m"
      label="\\\033[${style};${colorSubset}m"

      echo -ne "${tag}${label}${esc} │ "
    done
    echo
  done
  echo -ne "$table__Bottom $esc"
}

### run program
basicForeColors
basicBackColors

echo -e "$(wrapColorBold 32 "

DONE :)")"


