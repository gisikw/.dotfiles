function lint() {
  filewatcher -s -r '**/*.rb **/*.js **/*scss' 'echo $FILENAME; ext=${FILENAME##*\.}; case "$ext" in rb) rubocop $1;; js) eslint $1;; scss) scss-lint $1;;esac'
}
