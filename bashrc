function encrypt() {
  if [ ! -e "$HOME/.ssh/id_rsa.pub.pem" ]; then
    openssl rsa -in $HOME/.ssh/id_rsa -pubout > $HOME/.ssh/id_rsa.pub.pem 2>/dev/null
  fi
  cat $1 | openssl rsautl -encrypt -pubin -inkey $HOME/.ssh/id_rsa.pub.pem > $1.enc
}

function decrypt() {
  FILENAME=$(echo $1 | sed 's/\.[^.]*$//')
  cat $1 | openssl rsautl -decrypt -inkey $HOME/.ssh/id_rsa > $FILENAME 2>/dev/null
  cp $FILENAME $FILENAME.bak
}

function sdot() {
  update_dotfile_repository
  if [ ! -e "$HOME/.ssh/id_rsa.pub.pem" ]; then
    openssl rsa -in $HOME/.ssh/id_rsa -pubout > $HOME/.ssh/id_rsa.pub.pem 2>/dev/null
  fi
  cat $HOME/.dotfiles/secrets | openssl rsautl -decrypt -inkey $HOME/.ssh/id_rsa > /tmp/secrets 2>/dev/null
  vim /tmp/secrets &&
  cat /tmp/secrets | openssl rsautl -encrypt -pubin -inkey $HOME/.ssh/id_rsa.pub.pem > $HOME/.dotfiles/secrets 2>/dev/null
  rm /tmp/secrets
  commit_dotfile_changes
}

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
    git push origin master >/dev/null 2>&1
  )
}

if github_available; then
  # cmp ~/.dotfiles/secrets.sh ~/.dotfiles/secrets.sh.bak > /dev/null || encrypt ~/.dotfiles/secrets.sh
  commit_dotfile_changes
  update_dotfile_repository
  source $(cat $HOME/.dotfiles/secrets | openssl rsautl -decrypt -inkey $HOME/.ssh/id_rsa)
fi

function up() {
  source ~/.bash_profile 2>/dev/null || source ~/.bashrc 2>/dev/null
}

function reset() {
  for key in $(craml_all ~/.dotfiles/config.yml symlinks); do
    target="$HOME/$key"
    rm -rf $target
    ln -s $HOME/$(craml_value ~/.dotfiles/config.yml symlinks $key) $target
  done
}

# Yay VI!
set -o vi

# Set up utility functions
for file in ~/.dotfiles/bash/*; do
  source $file
done

# Verify symlinks
for key in $(craml_all ~/.dotfiles/config.yml symlinks); do
  target="$HOME/$key"
  if [ ! -e $target ]; then
    ln -s $HOME/$(craml_value ~/.dotfiles/config.yml symlinks $key) $target
  fi
done

# Set up aliases
for key in $(craml_all ~/.dotfiles/config.yml aliases); do
  alias $key="$(craml_value ~/.dotfiles/config.yml aliases $key)"
done

# Load secrets
if [ -e "$HOME/.dotfiles/secrets.sh" ]; then
  source ~/.dotfiles/secrets.sh
fi

# Ensure color terminal on Chromebooks
export TERM=xterm-256color

# Tidy up
# unset -f github_available
# unset -f commit_dotfile_changes
# unset -f update_dotfile_repository
