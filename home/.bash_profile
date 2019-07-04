export CLICOLOR=1

# Use terminal colors
if [ -z "$TERM" -o "$TERM" == "xterm" ] ; then
  export TERM="xterm-256color"
fi

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# bash configs
export HISTIGNORE="&:[bf]g:exit:[ ]*:umount"
export HISTCONTROL="ignorespace:ignoredups:erasedups"
export HISTSIZE="2000"
#shopt -s histappend
#PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# 2 (Two) cd extension
_2IGNORE="$HOME/.m2*:$HOME/.gradle*"

# TeamCity
export TEAMCITY_AGENT_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005 -Dteamcity.export.ec2.metadata=false"
export TEAMCITY_SERVER_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5500"
export TEAMCITY_DATA_PATH="../data"

# Java Related
#export M2_HOME="$HOME/maven"
export JRUBY_OPTS="-Xcext.enabled=false"

pathadd() {
  if [ -d "$1" ]; then
    if [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="$1:$PATH"
    #else
    #  PATH="$(echo "$1:$PATH" | awk -v RS=':' -v ORS=':' '!a[$1]++')"
    fi
  fi
}
pathadd_suffix() {
  if [ -d "$1" ]; then
    if [[ ":$PATH:" != *":$1:"* ]]; then
      PATH="$PATH:$1"
    else
      PATH="$(echo "$1:$PATH" | awk -v RS=':' -v ORS=':' '!a[$1]++')"
    fi
  fi
}

alias cd..="cd .."
alias got=git
alias gut=git
alias tmux='tmux attach || tmux new'

export P4CONFIG=.p4config

which rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

[ -f "$HOME/.rbenv/completions/rbenv.bash" ] && source "$HOME/.rbenv/completions/rbenv.bash"
[ -f "$HOME/.bash_profile.local" ] && source "$HOME/.bash_profile.local"
