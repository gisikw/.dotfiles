#!/bin/bash

if [ ! -d ~/.dotfiles ]; then
  which git > /dev/null || {
    echo "You must have git installed to use these dotfiles";  exit 1;
  }
  git clone git@github.com:gisikw/.dotfiles.git ~/.dotfiles &&
  if [ -f ~/.bash_profile ]; then
    echo "source ~/.dotfiles/bashrc" >> ~/.bash_profile
  else
    echo "source ~/.dotfiles/bashrc" >> ~/.bashrc
  fi
  echo "Congratulations, the dotfiles have been installed. Please restart your shell."
fi
