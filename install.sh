#!/bin/bash

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `[[ -n "$(command)" ]]`, `func "$(command)"`, pipes, etc.
# shellcheck disable=SC2312

set -u

# ==> Setup

SPACE_DEFAULT_GIT_REMOTE="https://github.com/peario/space"
SPACE_DEFAULT_TARGET_DIRECTORY="$HOME/space"

# Use values from environment if set.
SPACE_GIT_REMOTE="${SPACE_GIT_REMOTE:-"${SPACE_DEFAULT_GIT_REMOTE}"}"
SPACE_TARGET_DIRECTORY="${SPACE_TARGET_DIRECTORY:-"${SPACE_DEFAULT_TARGET_DIRECTORY}"}"

# The URLs with and without the '.git' suffix are the same Git remote. Do not prompt.
if [[ "${SPACE_GIT_REMOTE}" == "${SPACE_DEFAULT_GIT_REMOTE}.git" ]]; then
    SPACE_GIT_REMOTE="${SPACE_DEFAULT_GIT_REMOTE}"
fi

export SPACE_{GIT_REMOTE,TARGET_DIRECTORY}

# ==> Helper functions

# Check if script is printing to terminal or piped/sent to file
if [[ -t 1 ]]; then
    # If printing to terminal, use ANSI codes for colors
    tty_escape() { printf "\033[%sm" "$1"; }
else
    # If sending to a file, ignore ANSI codes
    tty_escape() { :; }
fi

# ANSI codes for styling
tty_mkbold() { tty_escape "1;$1"; }

# ANSI codes for colors
tty_red="$(tty_mkbold 31)"
tty_green="$(tty_mkbold 32)"
tty_yellow="$(tty_mkbold 33)"
tty_blue="$(tty_mkbold 34)"
tty_cyan="$(tty_mkbold 36)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

# Joins arguments with spaces, ensuring spaces within arguments are escaped
shell_join() {
    local arg
    printf "%s" "$1"
    shift
    for arg in "$@"; do
        printf " "
        printf "%s" "${arg// /\ }"
    done
}

# Removes trailing newline from the input string
chomp() {
    printf "%s" "${1/"$'\n'"/}"
}

# Prints an informative message prefixed with a blue "==>"
ohai() {
    printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

# Prints a warning message in red, sent to stderr
warn() {
    printf "${tty_yellow}warn${tty_reset}: %s\n" "$(chomp "$1")" >&2
}

# Prints a message and exits with error code 1
abort() {
    printf "%s\n" "$@" >&2
    exit 1
}

# Prints a message as "space: <message>"
say() {
    printf "%s\n" "$1"
}

# Checks if a command exists and aborts if not found
require_cmd() {
    if ! verify_cmd "$1"; then
        abort "need '$1' (command not found)"
    else
        say "found '$1'"
    fi
}

optional_cmd() {
    if ! verify_cmd "$1"; then
        warn "optional '$1' (command not found)"
    else
        say "found '$1'"
    fi
}

# Verifies presence of a command
verify_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    if ! "$@"; then err "command failed: $*"; fi
}

# Takes one character from user input, useful for confirmation prompts
getc() {
    local save_state
    save_state="$(/bin/stty -g)"
    /bin/stty raw -echo
    IFS='' read -r -n 1 -d '' "$@"
    /bin/stty "${save_state}"
}

# ==> Core functionality

main() {
    ohai "Bootstrapping Space, a nix-based dotfiles"

    # Check if we're within
    if grep -q docker /proc/1/cgroup || [[ -f "/.dockerenv" ]]; then
        say "$(
      cat <<EOS
Detected characteristics found in containers. Is this script currently running in a container?

Press any of [${tty_green}yY${tty_reset}] to confirm, press any other key to ${tty_red}deny${tty_reset}.
EOS
        )"

        getc c
        # Confirm if to delete `~/space` or path of the value of SPACE_TARGET_DIRECTORY
        if [[ "${c}" =~ [yY] ]]; then
            SPACE_IN_CONTAINER=1
        fi
    fi

    # Required commands for this script to work
    ohai "Querying for required commands"
    require_cmd git
    require_cmd rm

    # Optional commands which are used for
    ohai "Querying for optional commands, they won't be installed but are recommended"

    # Unique for nix
    if ! verify_cmd "nix"; then
        warn "optional 'nix' (command not found)"
        SPACE_HAS_NIX=false
    else
        say "found 'nix'"
        SPACE_HAS_NIX=true
    fi

    optional_cmd direnv
    optional_cmd ssh
    optional_cmd age

    ohai "Starting process of cloning ${SPACE_GIT_REMOTE}"

    # Check if the path `~/space` is available or value of SPACE_TARGET_DIRECTORY
    if [ -d "${SPACE_TARGET_DIRECTORY}" ]; then
        local c

        warn "$(
      cat <<EOS
The target directory ("${SPACE_TARGET_DIRECTORY}") already exists!
Do you wish to delete it to proceed with the bootstrapper?

Press any of [${tty_green}yY${tty_reset}] to proceed, press any other key to ${tty_red}abort${tty_reset}.
EOS
        )"

        getc c
        # Confirm if to delete `~/space` or path of the value of SPACE_TARGET_DIRECTORY
        if [[ "${c}" =~ [yY] ]]; then
            ohai "Deleting folder ${SPACE_TARGET_DIRECTORY}"
            ensure rm -r "${SPACE_TARGET_DIRECTORY}"
        else
            abort "$(
        cat <<EOS
Unable to bootstrap config if "${SPACE_TARGET_DIRECTORY}" is not available.
However, setting the environment variable "${tty_cyan}SPACE_TARGET_DIRECTORY${tty_reset}" allows you to change location of config.
EOS
            )"
        fi
    fi

    # Attempt to clone the repository of SPACE_GIT_REMOTE.
    # Using `ensure` means that if repo failed to clone it instantly terminates the script and prints
    # the failing command.
    ensure git clone "${SPACE_GIT_REMOTE}" "${SPACE_TARGET_DIRECTORY}"

    ohai "Successfully cloned \"${SPACE_GIT_REMOTE}\""

    # Offer to run installer for Nix if not installed
    if ! ${SPACE_HAS_NIX}; then
        ohai "Nix installer"

        if [[ -n "${SPACE_IN_CONTAINER}" ]]; then
            say "$(
        cat <<EOS
The Nix-command could not be found. Do you wish to install Nix?

NOTE: Since characteristics found in containers have been detected, the following args are added to the default command:
$ ... linux --init none --extra-conf "filter-syscalls = false"

Accepting will run the following command:
$ curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none --extra-conf "filter-syscalls = false"

Press any of [${tty_green}yY${tty_reset}] to accept, press any other key to ${tty_red}skip${tty_reset} and finish the bootstrapper.
EOS
            )"
        else
            say "$(
        cat <<EOS
The Nix-command could not be found. Do you wish to install Nix?

Accepting will run the following command:
$ curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

Press any of [${tty_green}yY${tty_reset}] to accept, press any other key to ${tty_red}skip${tty_reset} and finish the bootstrapper.
EOS
            )"
        fi

        getc c
        # Confirm if to run the Determinate Systems Nix Installer
        if [[ "${c}" =~ [yY] ]]; then
            ohai "Running the Determinate Nix Installer"

            # Depending on if the script is running a Docker Container, append extra args to make it work
            if [[ -n "${SPACE_IN_CONTAINER}" ]]; then
                ensure curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none --extra-conf "filter-syscalls = false"
            else
                ensure curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
            fi
        fi
    fi
}

# ==> Start program

main || exit 1
