#!/bin/bash

which sed > /dev/null || { echo "sed is not installed. Aborting."; exit 1; }
which git > /dev/null || { echo "git is not installed. Aborting."; exit 1; }

if [ ! -d ~/.dotfiles ]; then
  echo "The git repo hasn't been cloned. We would do so here."
  exit 1
fi

LATEST=$(git ls-remote --heads https://github.com/gisikw/dotfiles.git master | sed -e 's/[	,\s].*$//')
CURRENT=$(git ls-remote --heads ~/.dotfiles master | sed -e 's/[	,\s].*$//')

if [ "$CURRENT" = "$LATEST" ]; then
  echo "Congrats, you are up-to-date!"
else
  echo "Current repo SHA: $CURRENT"
  echo "Latest repo SHA: $LATEST"
  echo "Here we begin logic to update things"
fi
