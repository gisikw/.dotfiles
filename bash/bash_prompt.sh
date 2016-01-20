PROMPT_COMMAND=status_prompt

function status_prompt
{
  if [ "$?" -ne "0" ]; then
    PS1="\[\e[0;31m\]$\[\e[0m\] "
  else
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
      if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
        if [ ! test -z "$(git status --porcelain)" ]; then
          PS1="\[\e[0;33m\]$\[\e[0m\] "
        else
          PS1="\[\e[0;32m\]$\[\e[0m\] "
        fi
      else
        PS1="\[\e[0;32m\]$\[\e[0m\] "
      fi
    else
      PS1="\[\e[0;32m\]$\[\e[0m\] "
    fi
  fi
}
