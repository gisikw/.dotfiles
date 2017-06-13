# Take a filename, create filename.enc
function encrypt() {
  if [ ! -e "$HOME/.ssh/id_rsa.pub.pem" ]; then
    openssl rsa -in $HOME/.ssh/id_rsa -pubout > $HOME/.ssh/id_rsa.pub.pem
  fi
}

# Take a filename.env, create filename
function decrypt() {

}
