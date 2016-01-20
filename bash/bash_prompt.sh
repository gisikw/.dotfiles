PROMPT_COMMAND=status_prompt

function status_prompt
{
  if [ "$?" -ne "0" ]; then
    PS1="\[\e[0;31m\]$\[\e[0m\] "
  else
    if [ $(git status; echo "$?") == "0" ] || [ -z "$(git status --porcelain)" ]; then
      echo "Not a git repo, or clean git repo"
      PS1="\[\e[0;33m\]$\[\e[0m\] "
    else
      echo "messy git repo"
      PS1="\[\e[0;32m\]$\[\e[0m\] "
    fi
  fi
}
