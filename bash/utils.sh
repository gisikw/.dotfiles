function browser() {
  if hash xdg-open 2>/dev/null; then
    xdg-open $1 > /dev/null;
  elif hash open 2>/dev/null; then
    open $1 > /dev/null;
  fi
}

function gh() {
  if [ -z $1 ]; then
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

function timer() {
  date1=`date +%s`;
  while true; do
   echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
  done
}

function fetchGPG() {
  ssh $1 gpg --export-secret-key 3BA01FDFEC13B152 | gpg --import
}
