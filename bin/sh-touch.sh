#!/usr/bin/env bash
# Author (c) 2020-2023 Marcus Biesioroff biesior@gmail.com
#
# Donate author: https://paypal.me/biesior/4.99EUR
#
# Description:
# Allows to fast create (touch) bash scripts and optionally open it in preferred editor
# for more details run `sh-touch -h`

# Try to not change anything below
# If you think you can improve this script, share with us via:
# https://github.com/sh-touch/sh-touch/issues

UserConfigFile="$HOME/.sh-touch.defaults.sh"
if test -f "$UserConfigFile"; then
  # TODO this suspension need verification
  # shellcheck disable=SC1090
  source "$HOME/.sh-touch.defaults.sh"
else
  talk "No default config file found!"
fi

# Semantic version for this script:
SemanticProject='sh-touch'
SemanticVersion='0.9.3-beta'
SemanticRepository='https://github.com/sh-touch/sh-touched/'
SemanticFile='bin/sh-touch'

function exportSemantics() {
  export BASH_SEMANTIC_SCRIPT_PROJECT=$SemanticProject
  export BASH_SEMANTIC_SCRIPT_VERSION=$SemanticVersion
  export BASH_SEMANTIC_SCRIPT_REPOSITORY=$SemanticRepository
  export BASH_SEMANTIC_SCRIPT_FILE=$SemanticFile

  #optional output for debug
  echo
  echo "Exporting semantics for $SemanticProject ver. $SemanticVersion"
  echo "These will be available as:"
  echo
  echo "\$BASH_SEMANTIC_SCRIPT_PROJECT"
  echo "\$BASH_SEMANTIC_SCRIPT_VERSION"
  echo "\$BASH_SEMANTIC_SCRIPT_REPOSITORY"
  echo "\$BASH_SEMANTIC_SCRIPT_FILE"
  echo
}

DocumentStyle=default
if [ "$SHTOUCH_COLORS" = false ]; then DocumentStyle=raw; fi

# ┌──────────────────────┐                                            ┌───────┐
# │ Formatting functions ├────────────────────────────────────────────┤ start │
# └┬─────────────────────┘                                            └──────┬┘
#  │ Shared functions for content formatting                                 │
#  │ They are used for rendering help and also output of program             │
#  └─────────────────────────────────────────────────────────────────────────┘

#  ┌─────────────────────────────────────────────────────────────────────────┐
#──┤ Coloring functions, preferably don't use them directly                  │
#  │ Instead use styling functions which differs by selected style           │
#  └─────────────────────────────────────────────────────────────────────────┘

function wrapGreen() { echo -ne "\033[32m$1\033[0m"; }
function wrapGreenBold() { echo -ne "\033[1;32m$1\033[0m"; }
function wrapCyan() { echo -ne "\033[36m$1\033[0m"; }
function wrapDimmed() { echo -ne "\033[2;37m$1\033[0m"; }
function wrapError() { echo -ne "\033[1;31m$1!\033[0m"; }
function wrapWarning() { echo -ne "\033[1;31m$1!\033[0m"; }

#  ┌─────────────────────────────────────────────────────────────────────────┐
#──┤ Coloring functions, preferably don't use them directly                  │
#  │ Instead use styling functions which differs by selected style           │
#  └─────────────────────────────────────────────────────────────────────────┘

function catFile() { case $DocumentStyle in raw) echo -e "File's content:\n$1\n\n" ;; markdown) ;;
default | *)
  wrapGreenBold "File's content:"
  echo -e "\033[0;36m"
  cat "$1"
  echo -e "\033[0m" "$1"
  ;;
esac }
function programSuccess() { case $DocumentStyle in raw) echo -e "OK!\n$1\n\n" ;; markdown) ;; default | *) echo -e "\033[1;32mOK!\033[0m\n$1\n\n" ;; esac }
function programError() { case $DocumentStyle in raw) echo -e "Error!\n$1\n\n" ;; markdown) ;; default | *) echo -e "\033[1;31mError!\033[0m\n$1\n\n" ;; esac }
function text() { echo -e "$1"; }
function header() { case $DocumentStyle in raw) echo -e "* $2" ;;
markdown)
  # TODO this suspension need verification
  # shellcheck disable=SC2034
  for i in $(seq 1 "$1"); do echo -n "#"; done
  echo -ne " $2  "
  ;;
default | *) echo -e "\033[32m$2\033[0m\n" ;; esac }

function headerInline() { case $DocumentStyle in raw) echo -e "$1" ;; markdown) echo -e "$1" ;; default | *) echo -e "\033[0;33m$1\033[0m" ;; esac }
function badges() { case $DocumentStyle in raw) ;; markdown) printf "[![%s](https://img.shields.io/static/v1?label=Donate&message=paypal.me/biesior&color=brightgreen 'Donate the contributor via PayPal.me, amount is up to you')](https://www.paypal.me/biesior/4.99EUR)
[![State](https://img.shields.io/static/v1?label=sh-touch&message=${SemanticVersion}&color=blue 'Latest known version')](https://github.com/biesior/bash-scripts/)
[![Minimum bash version](https://img.shields.io/static/v1?label=bash&message=3.2+or+higher&color=blue 'Minimum Bash version to run this script')](https://www.gnu.org/software/bash/)
" "Donate" ;; default | *) ;; esac }

function inlineCode() { case $DocumentStyle in raw) echo -ne "$1" ;; markdown) echo -ne "\`$1\`" ;; default | *) wrapCyan "$1" ;; esac }
function inlineError() { case $DocumentStyle in raw) echo -ne "(Error!) $1" ;; markdown) echo -ne "(Error!)" ;; default | *) echo -ne "$(wrapError "ERROR!") $1" ;; esac }
function inlineWarning() { case $DocumentStyle in raw) echo -ne "(Warning) $1" ;; markdown) echo -ne "(Warning)" ;; default | *) echo -ne "$(wrapError "WARNING") $1" ;; esac }
function inlineSuccess() { case $DocumentStyle in raw) echo -ne "(OK!) $1" ;; markdown) echo -ne "(OK!) $1" ;; default | *) echo -ne "$(wrapGreenBold "OK!") $1" ;; esac }
function inlineShy() { case $DocumentStyle in raw) echo -ne "$1" ;; markdown) echo -ne "$1" ;; default | *) echo -ne "\033[2;37m$1\033[0m" ;; esac }
function inlineStepNumber() { case $DocumentStyle in raw) echo -ne "Step $1 of $2:" ;; markdown) echo -ne "Step $1 of $2:" ;; default | *) wrapDimmed "Step $1 of $2:" ;; esac }
function mdEndLine() { case $DocumentStyle in raw) ;; markdown) echo -ne "  " ;; default | *) ;; esac }
function inlineValue() {
  if [ "$2" = no-ticks ]; then Tick=''; else Tick="\`"; fi
  case $DocumentStyle in raw) echo -ne "$1" ;; markdown) echo -ne "${Tick}${1}${Tick}" ;; default | *) wrapGreen "$1" ;; esac
}
function turnOnCodeColor() { case $DocumentStyle in raw) ;; markdown) ;; default | *) echo -ne "\033[36m" ;; esac }
function turnOffCodeColor() { case $DocumentStyle in raw) ;; markdown) ;; default | *) echo -ne "\033[0m" ;; esac }
function codeBlock() { case $DocumentStyle in raw) echo -e "$2" ;; markdown) echo -e "\`\`\`$1\n$2\n\`\`\`" ;; *) wrapCyan "$2" ;; esac }
function startDocument() { echo -e "\n"; }
function finishDocument() { echo -e "\n"; }

##DocumentStyle='markdown'
#inlineValue "hahahha"
#echo
#codeBlock bash "kod
#kod"
#echo
#inlineStepNumber 3 4
#echo
#
#inlineSuccess "no to jazda!"
#echo
#
#echo konie110
#exit

#  ┌─────────────────────┐
#──┤ Talkative functions │
#  └─────────────────────┘

function talk() { echo -e "$(inlineValue "sh-touch:") $1"; }
function talkError() { talk "$(inlineError "$1")"; }
function talkWarning() { talk "$(inlineWarning "$1")"; }
function talkSuccess() { talk "$(inlineSuccess "$1")"; }
function talkSilent() { echo -e "$(inlineValue "         ") $1"; }
function talkOption() { echo -e "         $(inlineCode "$1"): $2"; }
function promptValue() { echo -ne "$(inlineValue "sh-touch$ ")"; }
function promptOption() { echo -ne "$(inlineValue "sh-touch? ")"; }
function interactiveQuit() {
  if [[ $1 == -newline ]]; then echo; fi
  talkSuccess "finishing, see ya later $(inlineValue ":)")"
  exit
}
function listOptionsComma() {
  for arg in "$@"; do
    echo -ne "$(inlineCode "${arg}")"
    # TODO this suspension need verification
    # shellcheck disable=SC2199
    if [[ $arg == "${@: -1}" ]]; then :; else echo -n ', '; fi
  done
}
function listOptionsSpace() {
  delimeter=''
  for arg in "$@"; do
    echo -ne "$(inlineCode "${arg}")"
    # TODO this suspension need verification
    # shellcheck disable=SC2199
    if [[ $arg == "${@: -1}" ]]; then :; else echo -n "$delimeter"; fi
  done
}

# ┌──────────────────────┐
# │ Formatting functions ├───────────────────────────────────────────────────┐
# └┬─────────────────────┘                                              ┌────┴┐
#  └────────────────────────────────────────────────────────────────────┤ end │
#                                                                       └─────┘

if [ "$1" = "" ]; then
  programError "No filename specified!
Use $(inlineCode "sh-touch -h") for help
 or $(inlineCode "sh-touch -i") for interactive mode"
  exit 1
fi

# ┌──────────────────────┐                                            ┌───────┐
# │ Render help          ├────────────────────────────────────────────┤ start │
# └┬─────────────────────┘                                            └──────┬┘
#  │ Showing main help                                                       │
#  └─────────────────────────────────────────────────────────────────────────┘
CURRENT_YEAR=$(date +%Y)
function renderHelp() {

  if [ "$2" = "markdown" ] || [ "$2" = "raw" ]; then
    DocumentStyle="$2"
  fi

  startDocument

  text "$(header 1 "Help for $(inlineValue $SemanticProject) ver. $(inlineValue "$SemanticVersion")")
$(badges)

$(header 3 "What it does?")

As name suggest $(inlineCode "touch") version of command for bash scripts.
It just creates scratch shell script with $(inlineValue ".sh") or $(inlineValue ".zsh"), proper shebang and sample code inside.

You can reuse sample code or remove it and write your own.

Just leave generated shebang.
See: https://en.wikipedia.org/wiki/Shebang_(Unix)

$(header 3 "Where")

$(inlineCode "<filepath>") is absolute or relative path for new created script, if filename only given it will create script in current directory

$(inlineCode "<extension>") should be $(inlineValue ".sh") or $(inlineValue ".zsh"), if not specified $(inlineValue ".sh") will be added automatically.

$(inlineCode "<output>") If specified, after creation the file it will be opened in this editor, possibilities:

  $(header 5 "Display")

  - $(inlineValue "cat") displays generated code with $(inlineCode "cat") command in terminal and returns to shell
  - $(inlineValue "none") or blank writes output file without displaying/editing and returns to shell

  $(header 5 "Command line editors (if installed)")

  - $(inlineValue "vim")
  - $(inlineValue "nano")
  - $(inlineValue "jed")

  $(header 5 "GUI editors on Mac (if installed)")

  - $(inlineValue "edit") for default OSX editor
  - $(inlineValue "sublime") for OSX Sublime Text.app
  - $(inlineValue "textedit") for OSX TextEdit.app

$(header 3 "Samples")

$(header 5 "(optionally)")

$(codeBlock bash "cd /path/with/your/executables")

$(header 5 "To create script with $(inlineValue "#!/usr/bin/env bash") $(headerInline 5 "shebang")")

$(codeBlock bash "sh-touch foo.sh")

$(header 5 "To create script with $(inlineCode "#!/usr/bin/env zsh") $(headerInline 5 "shebang")")
$(codeBlock bash "sh-touch foo.zsh")

$(header 5 "If extension is not given. default bash is created:")

$(inlineCode "sh-touch baz")  (creates $(inlineValue "baz.sh") with $(inlineValue "#!/usr/bin/env bash") shebang)

$(header 5 "Of course you can always use absolute or relative path for new file like:")

$(codeBlock bash "sh-touch /full/path/to/zen.sh
sh-touch ~/in-home-directory.sh
sh-touch in-current-directory.sh")

$(header 5 "If for some reason you want/need to use file without extension, just rename it after creation like")

$(codeBlock bash "mv new-script.sh new-script")

$(header 3 "Exported variables")

To modify final output you can export some variables in your shell before executing $(inlineCode "sh-touch")
or add selected exports to your profile file.

$(header 5 "To check current exported variables, just $(inlineCode echo) $(inlineValue 'one of them in your terminal, like') ")
$(codeBlock bash "echo \$SHTOUCH_DEFAULT")

$(header 5 "To disable sample body (allowed $(inlineCode 'true'), $(inlineCode 'false')):")
$(codeBlock bash "export SHTOUCH_BODY=false")

$(header 5 "To disable generator comment (allowed $(inlineCode 'true'), $(inlineCode 'false')):")
$(codeBlock bash "export SHTOUCH_COMMENT=false")

$(header 5 "To disable colored output (allowed $(inlineCode 'true'), $(inlineCode 'false')):")
$(codeBlock bash "export SHTOUCH_COLORS=false")

$(header 5 "To set default extension to be used when auto mode")
* required extension must be no-spaces word, starting with dot like $(inlineValue '.sh'), $(inlineValue '.zsh'), $(inlineValue '.my-own-extension')$(mdEndLine)
* suggested $(inlineValue '.sh') or $(inlineValue '.zsh')$(mdEndLine)
* default $(inlineValue '.sh')$(mdEndLine)
$(codeBlock bash "export SHTOUCH_DEFAULT=$(inlineValue '.sh' no-ticks)")


$(header 5 "That's all!")
Now you can run:
$(codeBlock bash "sh-touch have-fun-:-p")

© 2020-$CURRENT_YEAR Marcus biesior Biesioroff"

  finishDocument

}

# ┌───────────────────────┐                                           ┌───────┐
# │ Shared functions      ├───────────────────────────────────────────┤ start │
# └┬──────────────────────┘                                           └──────┬┘
#  │ Functions used by interactive and rendering func                        │
#  └─────────────────────────────────────────────────────────────────────────┘

CommonQuitMsg="Quits $(inlineCode 'sh-touch --interactive') (no file)"
#CommonRenameMsg="to change name of the output file"

InteractiveSteps=7

Shebang_SH="#!/usr/bin/env bash"
ScriptType_SH='bash'
ScriptExtension_SH='.sh'

Shebang_ZSH="#!/usr/bin/env zsh"
ScriptType_ZSH='zsh'
ScriptExtension_ZSH='.zsh'

function useShByDefault() {
  #  echo setting defaults for SH
  DefaultExtension=$ScriptExtension_SH
  Shebang=$Shebang_SH
  ScriptType=$ScriptType_SH
}

function useZshByDefault() {
  #  echo setting defaults for ZSH
  DefaultExtension=$ScriptExtension_ZSH
  Shebang=$Shebang_ZSH
  ScriptType=$ScriptType_ZSH
}

# may be changed in later code
useShByDefault

function validateFileName() {

  #    echo "Checkin filename"
  #    exit
  #  FileNameError=fooerror
  #  echo fne1 $FileNameError
  unset FileNameError

  if test -f "$1"; then
    talk "File $1 already exists"
  elif test -d "$1"; then
    talkError "File $(inlineCode "$1") is existing directory! Try again."
    FileNameError=true
  elif [[ "$1" == */ ]]; then
    talkError "File name cannot end with slash! Is it directory?"
    FileNameError=true
    echo fne2 $FileNameError
    #  str='some text with @ in it'
    #  if [[ $1 == *['!'@#\$%^\&*()_+]* ]]; then
    if [[ "$1" == *['!'@#,\$%^\&*\<\>]* ]]; then
      talkError "Forbidden characters used!"
      talkSilent "Please avoid these characters in filenames: $(listOptionsSpace "@" "#" "," "\$" "%" "^" "<" ">" "&" "*")"
      talkSilent "If you really need to use some crazy name,"
      talkSilent "just create file without forbidden characters and rename it in your OS!"
      talkSilent "Try again..."
      FileNameError=true
    elif [[ "$1" == -* ]]; then
      talkError "File name cannot start with hyphen-minus char! Did you mean $1?"
      FileNameError=true
    fi
  fi

  if [[ $FileNameError == "" ]]; then
    if [[ $SHTOUCH_DEFAULT == "" ]]; then
      talk -e "Please do not use empty extension with this script, \ninstead create file with real extension and rename it with $(inlineCode mv) command if really needed"
    elif [[ $SHTOUCH_DEFAULT == *.* ]]; then
      DefaultExtension=$SHTOUCH_DEFAULT
    fi

    if [[ $DefaultExtension == "" ]]; then
      DefaultExtension=".sh"
      talk "No extension specified $(inlineValue $DefaultExtension) used."
    fi
    if [[ $2 == "interactive" ]]; then
      FileName="$1"
      interactiveChooseType
    else
      FileName="$1"$DefaultExtension
      talk "Trying $FileName"
    fi

  else
    exit

  fi
}

# ┌──────────────────────┐                                            ┌───────┐
# │ Render output        ├────────────────────────────────────────────┤ start │
# └┬─────────────────────┘                                            └──────┬┘
#  │ Showing main help                                                       │
#  └─────────────────────────────────────────────────────────────────────────┘

function displayInvalidOutputOption() {
  echo -e "Invalid option for output, default used, next time try:

- Commandline editors:
  $(inlineValue "vim")
  $(inlineValue "nano")
  $(inlineValue "jed")

- OSX GUI editors
  $(inlineValue "edit") for system default editor
  $(inlineValue "sublime") for 'Sublime Text.app'
  $(inlineValue "textedit") for 'TextEdit.app'

    "
}

function renderOutput() {

  touch "$FileName"

  if [[ $SHTOUCH_COMMENT != 'false' ]]; then
    ScriptComment="# This $ScriptType script was touched by $SemanticProject $SemanticVersion
# $SemanticRepository
"
  fi
  if [[ $SHTOUCH_BODY != 'false' ]]; then
    ScriptBody="# Of course you can remove or replace this sample code
# Check documentation for permanent disabling it with exported variables
echo -e \"Hello World!

This file was created with $SemanticProject ver.: $SemanticVersion
\"

if [ -n \"\$BASH_VERSION\" ] >/dev/null; then
  echo \"Using bash shell ver.: \$BASH_VERSION\"
elif [ -n \"\$ZSH_VERSION\" ] >/dev/null; then
  echo \"Using zsh shell ver.: \$ZSH_VERSION\"
else
  echo \"Using another shell\"
fi

exit 0

# eof
"
  fi

  printf "%s

$ScriptComment
$ScriptBody

" "$Shebang" >>"$FileName"

  #echo "# eof"

  chmod +x "$FileName"

  programSuccess "Script $(inlineValue "$FileName") created and chmoded $(inlineValue "+x") "

  if [ "$2" ]; then
    case "$2" in
    "" | cat) catFile "$FileName" ;;
    vim) vim "$FileName" ;;
    nano) nano "$FileName" ;;
    jed) jed "$FileName" ;;
    edit) open -t "$FileName" ;;
    sublime) open -a "Sublime Text" "$FileName" ;;
    textedit) open -e "$FileName" ;;
    silent) ;;
    *) displayInvalidOutputOption ;;
    esac

  fi

  exit 0
}

# ┌───────────────────────┐                                           ┌───────┐
# │ Interactive functions ├───────────────────────────────────────────┤ start │
# └┬──────────────────────┘                                           └──────┬┘
#  │ Functions used for interactive mode                                     │
#  └─────────────────────────────────────────────────────────────────────────┘

function interactiveTestEnd() {
  Shebang="#!/usr/bin/env interactive"
  ScriptType="interactive"
  FileName="${1}interactive"
  renderOutput "$FileName" "cat"
}
function interactiveHelpSelectType() {
  talk "$(inlineValue "File extension help:")"
  talkSilent "$(inlineCode 1): Creates $(inlineValue "$ScriptType_SH") script with $(inlineValue "$Shebang_SH") shebang and $(inlineValue $ScriptExtension_SH) file extension"
  talkSilent "$(inlineCode 2): Creates $(inlineValue "$ScriptType_ZSH") script with $(inlineValue "$Shebang_ZSH") shebang and $(inlineValue $ScriptExtension_ZSH) file extension"
  talkSilent "$(inlineCode r): Change the name if target file already exists or you just want to use something else"
  talkSilent "$(inlineCode h): Displays this help"
  talkSilent "$(inlineCode q): Quits $(inlineCode "sh-touch --interactive") without creating any file"
}
function interactiveShowFileExtOptions() {
  talk "$(inlineStepNumber 2 $InteractiveSteps) Choose file extension for $(inlineCode "$FileName"):"
  talkSilent "$(inlineShy "(single keypress)")"
  talkOption 1 "$(inlineValue '.sh')"
  talkOption 2 "$(inlineValue '.zsh')"
  talkOption r "Rename file"
  talkOption h "Display help"
  talkOption q "$CommonQuitMsg"
  talkSilent
}
function interactiveChooseType() {

  if [[ "$1" == -error-wrong ]]; then
    echo
    talk "$(inlineError "$(inlineCode "$answer") is wrong option! Try again ($(listOptionsComma 1 2 r h x)")):"
  elif [[ "$1" != displayed ]]; then
    interactiveShowFileExtOptions
  fi

  promptOption

  turnOnCodeColor
  read -n 1 -r -p "" answer
  turnOffCodeColor

  case $answer in
  1) useShByDefault "$1" ;;
  2) useZshByDefault "$1" ;;
  r) interactiveStart -newline ;;
  h) interactiveChooseType ;;
  q) interactiveQuit -newline ;;
  *)
    FileName="${FileName}"
    interactiveChooseType -error-wrong
    ;;
  esac

  TempFileName="${FileName}${DefaultExtension}"
  if test -f "$TempFileName"; then
    echo
    talk "$(inlineError "File: $(inlineCode "$TempFileName") already exists, rename target file or use other localization.")"
    interactiveChooseType displayed
  fi

  FileName="${FileName}${DefaultExtension}"
  if ! command touch "$FileName" &>/dev/null; then
    talkError "File with this name cannot be created!"
    exit 1
  fi
  renderOutput

}

function zzzz() {
  echo " zzzz $1"
}

function interactiveAskFilename() {

  promptValue
  turnOnCodeColor
  read -rp "" answer
  turnOffCodeColor

  if [ "$answer" = '-q' ] || [ "$answer" = '--quit' ]; then
    interactiveQuit
  fi

  # TODO make interactive help
  if [ "$answer" = '?' ] || [ "$answer" = '-h' ] || [ "$answer" = '--help' ]; then
    renderHelp
  fi

  validateFileName "$answer" "interactive"
  if [[ $FileNameError == true ]]; then
    interactiveAskFilename
  fi
  talk "exiting interactive mode with no success"
  exit
}

function interactiveStart() {
  if [[ "$1" == -newline ]]; then echo; fi
  talk "$(inlineStepNumber 1 $InteractiveSteps) Input filename without extension"
  talkSilent "$(inlineShy "(write value and press enter)")"
  interactiveAskFilename
  exit
}

function interactiveWelcome() {
  talk "Welcome to interactive $(inlineValue "sh-touch") ver. $(inlineValue "$SemanticVersion")"
  talkSilent "Follow screen instructions to complete task"
  #  talkSilent "$(listOptionsComma '-r' '--rename'): $CommonRenameMsg"
  talkSilent "$(listOptionsComma '-q' '--quit'): $CommonQuitMsg"
  echo
  interactiveStart

}

# TODO optimize

FileName="$1"
if [[ "$FileName" == -h ]] || [[ "$FileName" == --help ]]; then
  renderHelp "$1" "$2"
  exit 0
elif [[ "$FileName" == -i ]] || [[ "$FileName" == --interactive ]]; then
  interactiveWelcome
  exit
elif [[ "$FileName" == --export-semantics ]]; then
  exportSemantics
  DoRenderOutput=false
elif [[ "$FileName" == *.sh ]]; then
  Shebang="#!/usr/bin/env bash"
  ScriptType="bash"
  FileName="$1"
elif [[ "$FileName" == *.zsh ]]; then
  ScriptType="zsh"
  Shebang="#!/usr/bin/env zsh"
  FileName="$1"
else
  if test -d "$FileName"; then
    programError "$(inlineValue "$FileName") is a directory!!"
    exit 1
  fi
  ScriptType="bash"
  Shebang="#!/usr/bin/env bash"
  FileName="${1}${DefaultExtension}"

fi

if [[ $DoRenderOutput != false ]]; then
  validateFileName "$1"
  renderOutput "$1" "$2"
fi
