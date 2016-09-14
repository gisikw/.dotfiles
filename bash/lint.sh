function lint() {
  filewatcher '**/*' 'lint_file $FILENAME'
}

function lint_file() {
  ext=${1##*\.}
  case "$ext" in
  rb) rubocop $1;;
  js) eslint $1;;
  scss) scss-lint $1;;
  esac
}
