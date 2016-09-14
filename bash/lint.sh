# function lint() {
#   # TODO: Use filewatcher '**/*.rb' and '**/*.js' and... etc, 'lint_file $FILENAME'
# }

function lint_file() {
  ext=${1##*\.}
  case "$ext" in
  rb) rubocop $1;;
  esac
}
