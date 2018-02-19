function af() {
  PATTERN=$1
  DIR=${2:-.}
  ag -Q --nogroup $PATTERN $DIR | cut -d':' -f1 | uniq
}
