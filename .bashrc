# .bashrc - Always executed for a new shell, unlike .bash_profile, 
#           which normally isn't run for terms without the -ls option

# NOTE: BSD systems will need a .bashrc.local to override ls...
#       BSD uses 'ls -G'
alias 'ls'='ls --color=auto'
alias 'sdiff'='diff -dbB --left-column --side-by-side'
alias 'ifbrief'='ifconfig | grep -E "Link|ether|inet|^[a-zA-Z]"'
alias 'awhois'='gwhois -h whois.arin.net'
alias 'cgrep'='grep --color=always'
alias 'wgrep'='grep -w --color=always'
alias 'minicom'='minicom -w'
alias tmux="TERM=screen-256color tmux"
alias tn="tmux new bash"  # The easiest way to ensure bash initializes well
alias 'vi'='vim'
alias 'rebash'='source ~/.bash_profile'

# I hate emacs line editing, use vi
#set -o vi

HISTSIZE=2000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignorespace:ignoredups
HISTTIMEFORMAT="%y-%m-%d %T "

history() {
  _bash_history_sync
  builtin history "$@"
}

_bash_history_sync() {
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
