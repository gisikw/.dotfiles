function status_prompt() {
  [ $? -ne 0 ] && color_code=31 || 
    { [ $(git status --porcelain=1 2>/dev/null | wc -l) -ne 0 ] && color_code=33 || 
      color_code=32; }
  PS1="\[\e[0;${color_code}m\]$\[\e[0m\] "
  [ -n "$SSH_CLIENT" ] && PS1="\[\e[0;36m\](\h)\[\e[0m\] $PS1"
}
PROMPT_COMMAND=status_prompt
