# Take a filename, create filename.enc
function encrypt() {
  if [ ! -e "$HOME/.ssh/id_rsa.pub.pem" ]; then
    openssl rsa -in $HOME/.ssh/id_rsa -pubout > $HOME/.ssh/id_rsa.pub.pem 2>/dev/null
  fi
}

# Take a filename.env, create filename
function decrypt() {

}
