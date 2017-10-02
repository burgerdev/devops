#!/bin/bash

apt-get update -qq
apt-get install -qq fish

fish_exec=`which fish`
if [[ -z "${fish_exec}" ]]
then
    echo "No fish installed." >&2
    exit 1
fi

shells="/etc/shells"
if ! grep -q -x -F "${fish_exec}" "${shells}"
then
    echo "${fish_exec} must be an entry in ${shells}." >&2
    exit 2
fi

# TODO: Unclear why, but chsh does prompt for a password with switch '-s'.
#       Piping the shell into it circumvents this problem, but is ugly.
chsh >/dev/null <<EOF
${fish_exec}
EOF
