function lint() {
  filewatcher -s -r '**/*.rb **/*.js **/*scss' 'echo $FILENAME; ext=${FILENAME##*\.}; case "$ext" in rb) rubocop $FILENAME;; js) eslint $FILENAME;; scss) scss-lint $FILENAME;;esac'
}
