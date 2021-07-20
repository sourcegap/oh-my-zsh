# vim:ft=zsh ts=2 sw=2 sts=2 nowrap

###########################
## <Description>
## author: bridgesj
###########################

## --- Environment Setup ---
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# set -o xtrace                 # print every command before executing (for debugging)
#set -o nounset                  # make using undefined variables throw an error
#set -o errexit                  # exit immediately if any command returns non-0
#set -o pipefail                 # exit from pipe if any command within fails
#set -o errtrace                 # subshells should inherit error handlers/traps
#shopt -s dotglob                # make * globs also match .hidden files
#shopt -s inherit_errexit        # make subshells inherit errexit behavior
#IFS=$'\n'                       # set array separator to newline to avoid word splitting bugs

## --- Imports ---

## --- Public Variables ---
ZSH_THEME_SOURCEGAP_PROMPT_BADGE_ERROR='✘'
ZSH_THEME_SOURCEGAP_PROMPT_BADGE_SUPER='⚡'
ZSH_THEME_SOURCEGAP_PROMPT_BADGE_JOBS='⚙'
ZSH_THEME_SOURCEGAP_PROMPT_CONTEXT_SEPERATOR='@'

ZSH_THEME_SOURCEGAP_PROMPT_USER_COLOR=''
ZSH_THEME_SOURCEGAP_PROMPT_HOST_COLOR=''
ZSH_THEME_SOURCEGAP_PROMPT_CONTEXT_SEPERATOR_COLOR=''

ZSH_THEME_SOURCEGAP_PROMPT_BADGE_ERROR_COLOR=''
ZSH_THEME_SOURCEGAP_PROMPT_BADGE_SUPER_COLOR=''
ZSH_THEME_SOURCEGAP_PROMPT_BADGE_JOBS_COLOR=''

ZSH_THEME_SOURCEGAP_PROMPT_DIRECTORY_COLOR=''

ZSH_THEME_SOURCEGAP_PROMPT_BADGE_FORMAT="${ZSH_THEME_SOURCEGAP_PROMPT_BADGE_SUPER_COLOR}%s${ZSH_THEME_SOURCEGAP_PROMPT_BADGE_ERROR_COLOR}%s${ZSH_THEME_SOURCEGAP_PROMPT_BADGE_JOBS_COLOR}%s$(tput sgr0)"
ZSH_THEME_SOURCEGAP_PROMPT_CONTEXT_FORMAT="${ZSH_THEME_SOURCEGAP_PROMPT_USER_COLOR}%s${ZSH_THEME_SOURCEGAP_PROMPT_CONTEXT_SEPERATOR_COLOR}%s${ZSH_THEME_SOURCEGAP_PROMPT_HOST_COLOR}%s$(tput sgr0)"
ZSH_THEME_SOURCEGAP_PROMPT_DIRECTORY_FORMAT="${ZSH_THEME_SOURCEGAP_PROMPT_DIRECTORY_COLOR}%s$(tput sgr0)"

## --- Private Variables ---

## --- Public Functions ---
function sourcegapPrompt.printBadges() {
  local retval=$1
  local -a badges

  [[ $EUID -eq 0 ]] && badges[1]="${ZSH_THEME_SOURCEGAP_PROMPT_BADGE_SUPER}"
  [[ $retval -ne 0 ]] && badges[2]="${ZSH_THEME_SOURCEGAP_PROMPT_BADGE_ERROR}"
  [[ $(jobs -l | wc -l) -gt 0 ]] && badges[3]="${ZSH_THEME_SOURCEGAP_PROMPT_BADGE_JOBS}"

  [[ ${#badges[@]} -gt 0 ]] && printf "${ZSH_THEME_SOURCEGAP_PROMPT_BADGE_FORMAT}" "${badges[1]}" "${badges[2]}" "${badges[3]}"
}

function sourcegapPrompt.printContext() {
  local user=$USER
  local host=$HOST

  printf "${ZSH_THEME_SOURCEGAP_PROMPT_CONTEXT_FORMAT}" "${user}" "${ZSH_THEME_SOURCEGAP_PROMPT_CONTEXT_SEPERATOR}" "${host}"
}

function sourcegapPrompt.printDirectory() {
  local hpwd

  case "${PWD}" in
    $HOME) hpwd="~";;
    $HOME/*/*) hpwd="~/../${PWD#"${PWD%/*/*}/"}";;
    $HOME/*) hpwd="~/${PWD##*/}";;
    /*/*/*) hpwd="/../${PWD#"${PWD%/*/*}/"}";;
    *) hpwd="${PWD}";;
  esac

  printf "${ZSH_THEME_SOURCEGAP_PROMPT_DIRECTORY_FORMAT}" "${hpwd}"
}

## --- Private Functions ---
function _sourcegapPrompt.main() {
}


## --- Script Execution ---

# run the main function to process the script
if [ "${1}" != "--source-only" ]; then
  _sourcegapPrompt.main "${@}"
fi

