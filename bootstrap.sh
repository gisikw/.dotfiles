#!/bin/bash

if [ ! -d ~/.dotfiles ]; then
  which git > /dev/null || { echo "Git not found";  exit 1; }
  which vim > /dev/null || { echo "Vim not found."; exit 1; }
  git clone git@github.com:gisikw/.dotfiles.git ~/.dotfiles && echo "Congratulations, the repo has been installed"
fi

vim -S ~/.dotfiles/.vim/symlinks
