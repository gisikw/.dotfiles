# CRappy yAML Parser

function craml_all() {
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 | awk '{ print $1 }' |
  sed 's/:$//'
}

function craml_value() {
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 |
  grep "^\s*$3:"
  awk '{ print substr($0, index($0, $2)) }'
}
