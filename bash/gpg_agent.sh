eval `gpg-agent --daemon --no-grab` 2>/dev/null
export GPG_TTY=`tty`
export GPG_AGENT_INFO=${HOME}/.gnupg/S.gpg-agent:0:1
