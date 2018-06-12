function es6() {
  NODE_PATH=$(npm -g root)
  in=$1
  out=$2
  echo $in | entr npx babel --no-babelrc --presets=es2015,react $in | npx prettier --parser babylon > $out
}
