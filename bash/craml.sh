# CRappy yAML Parser

function craml_all() {
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 2>/dev/null | awk '{ print $1 }' |
  sed 's/:$//'
}

function craml_value() {
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 2>/dev/null |
  grep "^\s*$3:" |
  awk '{ print substr($0, index($0, $2)) }'
}
