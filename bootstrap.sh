#!/bin/bash

TARGET=~/.dotfiles
REPO=git@github.com:gisikw/.dotfiles.git
SCRIPT="source ~/.dotfiles/bashrc"

if [ ! -d ~/.dotfiles ]; then
  which git > /dev/null || {
    echo "You must have git installed to use these dotfiles";  exit 1;
  }
  which yq > /dev/null || {
    echo "You must have yq installed to use these dotfiles";  exit 1;
  }
  git clone --quiet $REPO $TARGET >/dev/null 2>&1 && {
    if [ -f ~/.bash_profile ]; then
      echo $SCRIPT >> ~/.bash_profile
    else
      echo $SCRIPT >> ~/.bashrc
    fi
    echo "Congratulations, the dotfiles have been installed. Please restart your shell."
  } || {
    echo "Unable to access dotfiles repository. Could you be missing SSH keys?"; exit 1;
  }
else
  echo "The dotfiles are already installed."
  echo "Remove ~/.dotfiles and run this script again if you wish to reinstall."
fi
