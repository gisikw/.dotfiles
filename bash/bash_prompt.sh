PROMPT_COMMAND=status_prompt

function status_prompt
{
  if [ "$?" -eq "0" ]; then
    PS1="\[\e[0;32m\]$\[\e[0m\] "
  else
    PS1="\[\e[0;31m\]$\[\e[0m\] "
  fi
}
