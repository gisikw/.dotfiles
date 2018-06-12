function es6() {
  in=$1
  out=$2
  echo $in | entr "NODE_PATH=$(npm -g root) npx babel --no-babelrc --presets=es2015,react $in | npx prettier --parser babylon > $out"
}
