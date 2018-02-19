function af() {
  PATTERN=$1
  PATH=${2:-.}
  ack -Q --nogroup $PATTERN $PATH | cut -d':' -f1 | uniq
}
