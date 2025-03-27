export EDITOR=vim
dotfiles() {
  git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" "${@:-status}"
}
