function lint() {
  filewatcher -s -r '**/*.rb **/*.js **/*scss' 'ext=${1##*\.}; case "$ext" in rb) rubocop $1;; js) eslint $1;; scss) scss-lint $1;;esac'
}
