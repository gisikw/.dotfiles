function af() {
  PATTERN=$1
  DIR=${2:-.}
  ack -Q --nogroup $PATTERN $DIR | cut -d':' -f1 | uniq
}
