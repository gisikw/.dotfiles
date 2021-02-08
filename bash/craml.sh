# CRappy yAML Parser

# NOTE: Later versions of awk complain about "\ " as invalid, but it doesn't
# seem to affect behavior. Error messages have been suppressed. yq might be a
# viable alternative, but installation via snap on Ubuntu has some file access
# issues.

function craml_all() {
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 2>/dev/null | awk '{ print $1 }' |
  sed 's/:$//'
}

function craml_value() {
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 2>/dev/null |
  grep "^\s*$3:" |
  awk '{ print substr($0, index($0, $2)) }'
}
