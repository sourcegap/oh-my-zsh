# vim:ft=zsh ts=2 sw=2 sts=2 nowrap

###########################
## <Description>
## author: bridgesj
###########################

## --- Environment Setup ---
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
setopt promptsubst              #Re-evaluate prompt every time before showing
# set -o xtrace                  # print every command before executing (for debugging)
#set -o nounset                  # make using undefined variables throw an error
#set -o errexit                  # exit immediately if any command returns non-0
#set -o pipefail                 # exit from pipe if any command within fails
#set -o errtrace                 # subshells should inherit error handlers/traps
#shopt -s dotglob                # make * globs also match .hidden files
#shopt -s inherit_errexit        # make subshells inherit errexit behavior
#IFS=$'\n'                       # set array separator to newline to avoid word splitting bugs

## --- Imports ---

## --- Public Variables ---
fgBlack="$(tput setaf 0)"
fgRed="$(tput setaf 1)"
fgGreen="$(tput setaf 2)"
fgYellow="$(tput setaf 3)"
fgBlue="$(tput setaf 4)"
fgMagenta="$(tput setaf 5)"
fgCyan="$(tput setaf 6)"
fgWhite="$(tput setaf 7)"
txBold="$(tput bold)"
txReset="$(tput sgr0)"

ZSH_THEME_BORDER_COLOR=$txBold$fgBlue
ZSH_THEME_ROOT_BORDER_COLOR=$fgRed
ZSH_THEME_USER_COLOR=$fgWhite
ZSH_THEME_PROMPT_COLOR=$fgWhite
ZSH_THEME_HOST_COLOR=$fgWhite
ZSH_THEME_DIR_COLOR=$fgWhite
ZSH_THEME_DATE_COLOR=$fgWhite
ZSH_THEME_USER_HOST_SEPERATOR_COLOR=$fgYellow
ZSH_THEME_ERROR_COLOR=$fgYellow
ZSH_THEME_USER_HOST_SEPERATOR='@'
ZSH_THEME_USER_SYMBOL='🤠'
ZSH_THEME_ROOT_USER_SYMBOL='💀'

ZSH_THEME_BORDER_TL_CORNER='╭'
ZSH_THEME_BORDER_BL_CORNER='└'
ZSH_THEME_BORDER_HLINE='─'
ZSH_THEME_BORDER_OBRACKET='['
ZSH_THEME_BORDER_CBRACKET=']'
ZSH_THEME_BORDER_END='╼'
ZSH_THEME_BORDER_SPACER=' '
ZSH_THEME_HAS_CLOSED_SEGMENT=false

ZSH_THEME_GIT_PROMPT_PREFIX=''
ZSH_THEME_GIT_PROMPT_SUFFIX=''
ZSH_THEME_GIT_PROMPT_DIRTY=' ✗'
ZSH_THEME_GIT_PROMPT_CLEAN=' ✓'

## --- Private Variables ---
_HAS_CLOSED_SEGMENT=false

## --- Public Functions ---
function layout.printSegment() {
  local msg=$1
  local isBold="${2:-false}"

  if [[ ! -z "${msg}" ]]; then
    [[ $_HAS_CLOSED_SEGMENT ]] && layout.printSeperator; _HAS_CLOSED_SEGMENT=false
    printf "${ZSH_THEME_BORDER_COLOR}%s${txReset}" "${ZSH_THEME_BORDER_OBRACKET}"
    [[ ${isBold} == "true" ]] && printf "${txBold}"
    printf "%s${txReset}${ZSH_THEME_BORDER_COLOR}%s${txReset}" "${msg}" "${ZSH_THEME_BORDER_CBRACKET}"
    _HAS_CLOSED_SEGMENT=true
  fi
}

function layout.printSeperator() {
  local count=${1:-1}

  printf "${ZSH_THEME_BORDER_COLOR}"
  for ((i=0; i < $count; i++)); do
    printf "${ZSH_THEME_BORDER_HLINE}"
  done
  printf "${txReset}"
}

function layout.startLine() {
  local lineIndent="${1:-0}"
  local isMultiLine=true

  if [[ lineIndent -eq 0 ]]; then
    if [[ isMultiLine ]]; then
      printf "${ZSH_THEME_BORDER_COLOR}%s${txReset}" "${ZSH_THEME_BORDER_TL_CORNER}"
    fi
  else
    printf "${ZSH_THEME_BORDER_COLOR}%s${txReset}" "${ZSH_THEME_BORDER_BL_CORNER}"
    layout.printSeperator $lineIndent
  fi

  _HAS_CLOSED_SEGMENT=false
}

function layout.endLine() {
  printf '\n'
}

function layout.endPrompt() {
  printf "${ZSH_THEME_BORDER_COLOR}%s${txReset}" "${ZSH_THEME_BORDER_END}"
  printf "${PROMPT_COLOR}%s${txReset}" "${ZSH_THEME_USER_SYMBOL} "
}

## --- Private Functions ---
## Main prompt
function _sourcegap_ascii.main() {
  RETVALld_=$?

  layout.startLine
  layout.printSegment "$(sourcegapPrompt.printBadges $RETVALld_)"
  layout.printSegment "$(sourcegapPrompt.printContext)"
  layout.printSegment "$(sourcegapPrompt.printDirectory)"
  layout.endLine

  layout.startLine 2
  layout.printSegment "$(git_prompt_info)"
  layout.endPrompt
}

function _updateUserSettings() {
  if [[ $EUID == 0 ]]; then
    ZSH_THEME_BORDER_COLOR="${ZSH_THEME_ROOT_BORDER_COLOR}"
    ZSH_THEME_USER_SYMBOL="${ZSH_THEME_ROOT_USER_SYMBOL}"
  fi
}

## --- Script Execution ---

# run the main function to process the script
PROMPT='$(_sourcegap_ascii.main)'
