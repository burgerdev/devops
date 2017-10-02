#!/bin/bash

dotfiles="${DEVOPS_DOTFILES:-https://raw.githubusercontent.com/burgerdev/dotfiles/master}"

if (( "${#DEVOPS_DOTFILES_CURL[*]}" < 1))
then
    DEVOPS_DOTFILES_CURL=(curl -sL)
fi

"${DEVOPS_DOTFILES_CURL[@]}" "${dotfiles}/install.sh" | \
    env DOTFILES_REMOTE="${DEVOPS_DOTFILES_REMOTE:-true}" bash
