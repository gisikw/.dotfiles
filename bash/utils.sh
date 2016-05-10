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
