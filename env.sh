export EDITOR=vim
config() {
  git --git-dir="$HOME/.config/.git" --work-tree="$HOME/.config" "${@:-status}"
}
