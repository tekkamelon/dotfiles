# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# my config

# alias
alias w3b='w3m -B'
alias shutdown='systemctl poweroff'
alias reboot='systemctl reboot'
alias vi='vim.tiny -c "set nu"'
alias vim='vim.tiny -c "set nu"'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lv='ls -1'
alias lva='ls -1 -v -a'
alias lvd='ls -d .*'

# environment variable and PATH
export EDITOR=nvim
export W3MIMGDISPLAY_PATH=/usr/lib/w3m/w3mimgdisplay
export PATH=$PATH:/opt/processing-3.5.4/
export PATH=$PATH:/usr/sbin/

# vi mode
set -o vi

