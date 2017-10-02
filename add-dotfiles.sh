#!/bin/bash

dotfiles="${DEVOPS_DOTFILES:-https://raw.githubusercontent.com/burgerdev/dotfiles/master}"

if (( $# > 0 ))
then
    DEVOPS_DOTFILES=("$@")
else
    DEVOPS_DOTFILES_CURL=(curl -sL)
fi

"${DEVOPS_DOTFILES_CURL[@]}" "${dotfiles}/install.sh" | \
    env DOTFILES_REMOTE="${DEVOPS_DOTFILES_REMOTE:-true}" bash
