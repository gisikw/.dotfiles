function lint() {
  filewatcher -s -r '**/*.rb **/*.js **/*scss' 'echo $FILENAME; ext=${FILENAME##*\.}; case "$ext" in rb) rubocop $FILENAME;; js) eslint $FILENAME;; scss) scss-lint $FILENAME;;esac'
}

function lintgo() {
  filewatcher -r '**/*.go' 'out=$(golint $FILENAME); if [ -z "$out" ]; then echo "\\033[0;32mAll Good\\033[0m"; else echo "\\033[0;33m$out\\033[0m"; fi'
}
