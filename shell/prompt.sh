function get_named_color() {
  case $1 in
    31) echo "red" ;;
    32) echo "green" ;;
    33) echo "yellow" ;;
    36) echo "cyan" ;;
    *) echo "default" ;;
  esac
}

function status_prompt() {
  if [ $? -ne 0 ]; then
    STATUS="red"
  else
    [ $(git status --porcelain=1 2>/dev/null | wc -l) -ne 0 ] && STATUS="yellow" || STATUS="green"
  fi
  { read GROOT; read BRANCH } < <(git rev-parse --show-toplevel --abbrev-ref HEAD 2>/dev/null)
  LOCATION="$HOST"
  [ ! -z "$GROOT" ] && LOCATION="$LOCATION/$(basename $GROOT)"
  [ ! -z "$BRANCH" ] && [ "$BRANCH" != "master" ] && [ "$BRANCH" != "main" ] && LOCATION="$LOCATION#$BRANCH"
  NEWLINE=$'\n'
  PROMPT="%K{$STATUS}%F{black} $LOCATION %F{$STATUS}%k${NEWLINE}%K{$STATUS}%k%f "
}

if [[ $ZSH_NAME ]]; then
  precmd() { status_prompt; }
else
  PROMPT_COMMAND=status_prompt
fi
