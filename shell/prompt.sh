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
  [ $? -ne 0 ] && color_code=31 || 
    { [ $(git status --porcelain=1 2>/dev/null | wc -l) -ne 0 ] && color_code=33 || 
      color_code=32; }

  if [[ $ZSH_NAME ]]; then
    named_color=$(get_named_color $color_code)
    PROMPT="%F{$named_color}%f "
    [ -n "$SSH_CLIENT" ] && PROMPT="%K{$named_color}%F{black}(%m)%f %k$PROMPT"
  else
    PS1="\[\e[0;${color_code}m\]\[\e[0m\] "
    [ -n "$SSH_CLIENT" ] && PS1="\[\e[0;36m\](\h)\[\e[0m\] $PS1"
  fi
}

if [[ $ZSH_NAME ]]; then
  precmd() { status_prompt; }
else
  PROMPT_COMMAND=status_prompt
fi
