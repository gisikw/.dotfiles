# CRappy yAML Parser

function craml_all() {
  # FIXME: The awk objects to "\ " in contemporary versions of Ubuntu. Use yq
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 | awk '{ print $1 }' |
  sed 's/:$//'
}

function craml_value() {
  # FIXME: The awk objects to "\ " in contemporary versions of Ubuntu. Use yq
  awk "/$2:/{p=1;next;print;}p&&/^[^\ ]/{p=0};p" $1 |
  grep "^\s*$3:" |
  awk '{ print substr($0, index($0, $2)) }'
}
