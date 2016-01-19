function github_available() {
  echo -e "GET http://github.com HTTP/1.0\n\n" |
  nc github.com 80 > /dev/null 2>&1;
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
    git push origin master >/dev/null 2>&1
  )
}

if github_available; then
  commit_dotfile_changes
  update_dotfile_repository
fi

function up() {
  source ~/.bash_profile 2>/dev/null ||
  source ~/.bash_profile 2>/dev/null
}

# TODO:
# Verify symlinks
if [ ! -e ~/.vimrc ]; then
  ln ~/.dotfiles/vimrc ~/.vimrc
fi

# Set up aliases
# Set up utility functions
# Handle SSH agent

source ~/.dotfiles/bash_prompt
unset -f github_available
unset -f commit_dotfile_changes
unset -f update_dotfile_repository
