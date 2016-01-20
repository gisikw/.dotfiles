PROMPT_COMMAND=status_prompt

function status_prompt
{
  if [ "$?" -ne "0" ]; then
    PS1="\[\e[0;31m\]$\[\e[0m\] "
  else
    gstatus="$(git status --porcelain 2>/dev/null | wc -c)"
    if [ "$?" -ne "0" ] || [ "$gstatus" -eq "0" ]
      echo "Not a git repo, or clean git repo"
      PS1="\[\e[0;32m\]$\[\e[0m\] "
    else
      echo "messy git repo"
      PS1="\[\e[0;33m\]$\[\e[0m\] "
    fi
  fi
}
