function github_available() {
  ping -c 1 -W 1 github.com > /dev/null 2>&1
}

function commit_dotfile_changes() {
  (
    cd ~/.dotfiles
    if ! test -z "$(git status --porcelain)"; then
      git add --all >/dev/null 2>&1
      git commit -m "Automatic update" >/dev/null 2>&1
    fi
  )
}

function update_dotfile_repository() {
  (
    cd ~/.dotfiles
    git pull origin master >/dev/null 2>&1
    git push origin master >/dev/null 2>&1 &
  )
}

if github_available; then
  commit_dotfile_changes
  update_dotfile_repository
fi

function up() {
  source ~/.bash_profile 2>/dev/null || source ~/.bashrc 2>/dev/null
}

# function reset() {
#   for key in $(craml_all ~/.dotfiles/config.yml symlinks); do
#     target="$HOME/$key"
#     rm -rf $target
#     ln -s $HOME/$(craml_value ~/.dotfiles/config.yml symlinks $key) $target
#   done
# }

# Yay VI!
set -o vi

# Set up utility functions
for file in ~/.dotfiles/bash/*; do
  source $file
done

# Verify symlinks
cat ~/.dotfiles/config.yml | yq e '.symlinks' - | while read kv; do
  key=$(echo $kv | cut -f1 -d:)
  val=$(echo $kv | cut -f2 -d' ')
  target="$HOME/$key"
  if [ ! -e $target ]; then
    ln -s $HOME/$val $target
  fi
done

# Verify aliases
cat ~/.dotfiles/config.yml | yq e '.aliases' - | while read kv; do
  key=$(echo $kv | cut -f1 -d:)
  val=$(echo $kv | cut -f2 -d' ')
  echo "alias $key=\"$val\""
  alias $key="$val"
done

# Load secrets
if [ -e "$HOME/.dotfiles/secrets.sh" ]; then
  source ~/.dotfiles/secrets.sh
fi

# Ensure color terminal on Chromebooks
export TERM=xterm-256color
export BASH_SILENCE_DEPRECATION_WARNING=1

export BASH_SILENCE_DEPRECATION_WARNING=1

# Tidy up
# unset -f github_available
# unset -f commit_dotfile_changes
# unset -f update_dotfile_repository
