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
alias tmux="TERM=screen-256color tmux"
alias 'vi'='vim'
alias 'rebash'='source ~/.bash_profile'

# I hate emacs line editing, use vi
set -o vi

# Set a default bash prompt...
PS1='[\u@\h \W]\$ '
export PS1

# Get the LOCAL aliases and functions
if [ -f ~/.bashrc.local ]; then
        . ~/.bashrc.local
fi
