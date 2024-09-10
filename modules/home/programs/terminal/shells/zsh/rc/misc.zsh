# Hyperoptimized time format for the time command
# the definition of the format is as follows:
# - "[%J]": The name of the job.
# - "%uU user": CPU seconds spent in user mode.
# - "%uS system": CPU seconds spent in kernel mode.
# - "%uE/%*E elapsed": Elapsed time in seconds
# - "%P CPU": The CPU percentage, computed as 100*(%U+%S)/%E.
# - "(%X avgtext + %D avgdata + %M maxresident)k": The average amount in (shared) text space used in kilobytes, the
# average amount in (unshared) data/stack space used in kilobytes, and the maximum memory
# the process had in use at any time in kilobytes.
# - "[%I inputs / %O outputs]": Number of input and output operations
# - "(%Fmajor + %Rminor) pagefaults": The number of major & minor page faults.
# - "%W swaps": The number of times the process was swapped.
TIMEFMT=$'\033[1m[%J]\033[0m: %uU user | %uS system | %uE/%*E elapsed | %P CPU\n> (%X avgtext + %D avgdata + %M maxresident)k used\n> [%I inputs / %O outputs] | (%Fmajor + %Rminor) pagefaults | %W swaps'

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt* | Eterm | aterm | kterm | gnome* | alacritty | kitty*)
  TERM_TITLE=$'\e]0;%n@%m: %1~\a'
  ;;
*) ;;
esac

# enable keyword-style arguments in shell functions
set -k

# Colors
autoload -Uz colors && colors

# Autosuggest
ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HISTORY_IGNORE=$'*\n*'

# Improve paste delay for nix store paths
FAST_HIGHLIGHT[use_async]=1

# open commands in $EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
    [[ $1 == 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} == '' ]] ||
    [[ $1 == 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
  # zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'                # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q'; } # Use beam shape cursor for each new prompt.
