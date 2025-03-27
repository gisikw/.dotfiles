export EDITOR=vim
config() {
  git --git-dir="$HOME/.config" "${@:-status}"
}
