# function lint() {
#   # TODO: Use filewatcher '**/*.rb' and '**/*.js' and... etc, 'lint_file $FILENAME'
# }

function lint_file() {
  if [[ $1 == *.rb ]]; then
    rubocop $1
  fi
}
