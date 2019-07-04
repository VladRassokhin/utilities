export TEAMCITY_DATA_PATH="../data"
export TEAMCITY_SERVER_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5500"

#Some alisases for gnu utilities
alias sort=gsort
alias ll="ls -l"

# grep should be colorized
#export GREP_OPTIONS='--color=auto'

[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
[ -f "$HOME/.rbenv/completions/rbenv.bash" ] && source "$HOME/.rbenv/completions/rbenv.bash"

[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
