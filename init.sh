source $HOME/.dotfiles/shell/prompt.sh

while read target src; do
  target="$HOME/$target"
  if [ ! -e $target ]; then
    mkdir -p $(dirname $target)
    ln -s $HOME/$src $target
  fi
done < <(yq '.symlinks' $HOME/.dotfiles/config.yml | sed 's/://')

while read name cmd; do
  alias $name="$cmd"
done < <(yq '.aliases' $HOME/.dotfiles/config.yml | sed 's/://')
