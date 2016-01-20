function gh() {
  if [ -z $1 ]; then
    open https://github.com/$(git remote show origin | grep "Fetch URL" | sed 's/.*github.com:\(.*\)\.git/\1/')
  else
    open https://github.com/$1
  fi
}
