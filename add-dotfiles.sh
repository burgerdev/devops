#!/bin/sh

dotfiles="/tmp/dotfiles-$$"

git clone https://github.com/burgerdev/dotfiles.git "$dotfiles"
cp "$dotfiles"/bashrc $HOME/.bashrc
cp "$dotfiles"/vimrc $HOME/.vimrc
