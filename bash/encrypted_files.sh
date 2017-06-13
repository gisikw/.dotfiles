# Take a filename, create filename.enc
function encrypt() {
  if [ ! -e "$HOME/.ssh/id_rsa.pub.pem" ]; then
    openssl rsa -in $HOME/.ssh/id_rsa -pubout > $HOME/.ssh/id_rsa.pub.pem 2>/dev/null
  fi
  cat $1 | openssl rsautl -encrypt -pubin -inkey $HOME/.ssh/id_rsa.pub.pem > $1.enc
}

# Take a filename.env, create filename
function decrypt() {
  cat $1 | openssl rsautl -decrypt -inkey ~/.ssh/id_rsa > $(echo $1 | sed 's/\.[^.]*$//')
}
