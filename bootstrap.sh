#!/bin/bash

which git > /dev/null || { echo "git is not installed. Aborting."; exit 1; }

if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/gisikw/dotfiles.git ~/.dotfiles && echo "Congratulations, the repo has been installed"
fi

ln -nfs ~/.dotfiles/.vimrc ~/.vimrc
ln -nfs ~/.dotfiles/.vim ~/.vim
