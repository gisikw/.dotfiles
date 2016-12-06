function browser() {
  if hash open 2>/dev/null; then
    open $1;
  elif hash xdg-open 2>/dev/null; then
    xdg-open $1;
  fi
}

function gh() {
  if [ -z $1 ]; then
    echo https://github.com/$(git remote show origin | grep "Fetch URL" | sed 's/.*github.com:\(.*\)\.git/\1/')
    browser https://github.com/$(git remote show origin | grep "Fetch URL" | sed 's/.*github.com:\(.*\)\.git/\1/')
  else
    browser https://github.com/$1
  fi
}

function gz() {
  echo "orig size    (bytes): "
  cat "$1" | wc -c
  echo "gzipped size (bytes): "
  gzip -c "$1" | wc -c
}
