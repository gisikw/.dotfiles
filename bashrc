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

# FIXME: Aliases shouldn't exist in the main bashrc
function up() {
  if github_available; then
    commit_dotfile_changes
    update_dotfile_repository
  fi
  if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
  else
    source ~/.bashrc
  fi 
}
alias up="source 
echo "Testing autoupdate"

# TODO:
# Verify symlinks
# Set up aliases
# Set up utility functions
# Handle SSH agent
# Set bash prompt
