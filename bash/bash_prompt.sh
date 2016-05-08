PROMPT_COMMAND=status_prompt

function status_prompt() {
  if [ "$?" -ne "0" ]; then
    PROMPT="\[\e[0;31m\]$\[\e[0m\] "
  else
    # Skip git test on mounted volumes
    if [[ "$(pwd)" == "/Volumes/"* ]]; then
      PROMPT="\[\e[0;32m\]$\[\e[0m\] "
    else
      gstatus="$(git status --porcelain 2>/dev/null | wc -c)"
      if [ "$?" -ne "0" ] || [ "$gstatus" -eq "0" ]; then
        PROMPT="\[\e[0;32m\]$\[\e[0m\] "
      else
        PROMPT="\[\e[0;33m\]$\[\e[0m\] "
      fi
    fi
  fi
  if [ -n "$SSH_CLIENT" ]; then
    PS1="(\h) $PROMPT"
  else
    PS1=$PROMPT
  fi
}
