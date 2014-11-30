#!/bin/bash

which sed > /dev/null || { echo "sed is not installed. Aborting."; exit 1; }
which git > /dev/null || { echo "git is not installed. Aborting."; exit 1; }

if [ ! -d ~/.dotfiles/.git ]; then
  git clone https://github.com/gisikw/dotfiles.git ~/.dotfiles && echo "Congratulations, the repo has been installed"
else
  LATEST=$(git ls-remote --heads https://github.com/gisikw/dotfiles.git master | sed -e 's/[	,\s].*$//')
  CURRENT=$(git ls-remote --heads ~/.dotfiles master | sed -e 's/[	,\s].*$//')

  if [ "$CURRENT" = "$LATEST" ]; then
    echo "Congrats, you are up-to-date!"
  else
    cd ~/.dotfiles && git pull origin master && echo "Congrats, you are up-to-date!"
  fi
fi

ln -nfs ~/.dotfiles/vim/dotvimrc ~/.vimrc
ln -nfs ~/.dotfiles/vim/dotvim ~/.vim
