#!/usr/bin/env bash

# Install dot files.
# Modified 2019-06-17.

# Always skip dot file generation for root user.
[[ "$(id -u)" -eq 0 ]] && return 0

printf "\nConfiguring dotfiles.\n"

os="${KOOPA_OS_NAME:-}"
host="${KOOPA_HOST_NAME:-}"

dotfile -f Rprofile
dotfile -f atom
dotfile -f bash_profile
dotfile -f bashrc
dotfile -f condarc
dotfile -f doom.d
dotfile -f gitignore
dotfile -f kshrc
dotfile -f screenrc
dotfile -f shrc
dotfile -f spacemacs
dotfile -f tmux.conf
dotfile -f vim
dotfile -f vimrc
dotfile -f zshrc

# R
if [[ "$os" == "darwin" ]]
then
    dotfile -f os/darwin/R
    dotfile -f os/darwin/Renviron
elif [[ "$host" == "harvard-o2" ]]
then
    dotfile -f host/harvard-o2/Renviron
elif [[ "$host" == "harvard-odyssey" ]]
then
    dotfile -f host/harvard-odyssey/Renviron
fi

# Mike only files.
if [[ "${mike:-}" -eq 1 ]]
then
    dotfile -f forward
    if [[ "$os" == "darwin" ]]
    then
    dotfile -f os/darwin/gitconfig
    else
        dotfile -f gitconfig
    fi
fi
