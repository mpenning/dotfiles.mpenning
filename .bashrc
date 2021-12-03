# .bashrc - Always executed for a new shell, unlike .bash_profile, 
#           which normally isn't run for terms without the -ls option

# Run a whois query that retrieves info from Team CYMRU about an IP
function cwhois_fn {
    whois -h whois.cymru.com " -v $1"
}

# NOTE: BSD systems will need a .bashrc.local to override ls...
#       BSD uses 'ls -G'
alias 'ls'='ls --color=auto'
alias 'sdiff'='diff -dbB --left-column --side-by-side'
alias 'ifbrief'='ifconfig | grep -E "Link|ether|inet|^[a-zA-Z]"'
alias 'cgrep'='grep --color=always'
alias 'wgrep'='grep -w --color=always'
alias 'minicom'='minicom -w'
alias tmux="TERM=screen-256color tmux"
alias tn="tmux new bash"  # The easiest way to ensure bash initializes well
alias 'vi'='vim'
alias 'rebash'='source ~/.bash_profile'
alias 'awhois'='gwhois -h whois.arin.net'
# Call the cwhois_fn with the arg...
alias 'cwhois'=cwhois_fn
alias 'ssh'='ssh -o "ServerAliveInterval=60" -o "ConnectTimeout=1"'

# Use vi for term line edits
set -o vi


## Bash history hacks
##  http://unix.stackexchange.com/a/48116/6766
HISTSIZE=2000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignorespace:ignoredups
HISTTIMEFORMAT="%y-%m-%d %T "
function history {
  _bash_history_sync
  builtin history "$@"
}
function _bash_history_sync {
  builtin history -a         #1
  HISTFILESIZE=$HISTSIZE     #2
  builtin history -c         #3
  builtin history -r         #4
}
PROMPT_COMMAND=_bash_history_sync

# Set a default bash prompt...
PS1='[\u@\h \W]\$ '

export PS1 PROMPT_COMMAND HISTFILESIZE HISTTIMEFORMAT HISTCONTROL HISTSIZE

# Get the LOCAL aliases and functions
if [ -f ~/.bashrc.local ]; then
        . ~/.bashrc.local
fi
