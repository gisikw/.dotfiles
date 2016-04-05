function gh() {
  if [ -z $1 ]; then
    open https://github.com/$(git remote show origin | grep "Fetch URL" | sed 's/.*github.com:\(.*\)\.git/\1/')
  else
    open https://github.com/$1
  fi
}

function gz() {
  echo "orig size    (bytes): "
  cat "$1" | wc -c
  echo "gzipped size (bytes): "
  gzip -c "$1" | wc -c
}

function m2() {
  if [ -z $1 ]; then
    echo "Err: Specify branch to merge to"
    exit 1
  fi
  target_branch=$1
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  git checkout $target_branch &&
  git pull origin $target_branch &&
  git merge $current_branch
}

function rb() {
  if [ -z $1 ]; then
    echo "Err: Specify branch to rebase onto"
    exit 1
  fi
  target_branch=$1
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  git checkout $target_branch
  git pull origin $target_branch
  git checkout $current_branch
  git rebase $target_branch
}
