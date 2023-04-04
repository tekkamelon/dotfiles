# PS1='$(whoami)@$(hostname) > '

PS1='$(print -n "\033[32m${USER}@$(hostname) ";[[ "$HOME" == "$PWD" ]] && print -n "~" ||([[ "${PWD##*/}" == "" ]] && print -n "/" || print -n "${PWD##*/}");print "$ ")'

# viモードに設定
set -o vi

# ====== エイリアスの設定 ======
# ソフトの起動
alias popshop='io.elementary.appcenter'
alias scad='openscad' 
alias w3b='w3m -B'

# vimの設定
alias vim='nvim'
alias vit='nvim -c Bterm'
alias vi='nvim -u $HOME/.config/nvim/light_init.vim -c "set nonumber" -c "syntax off"'
alias vp="nvim -R -u $HOME/.config/nvim/light_init.vim - "
alias gdv='git diff | nvim -R -u $HOME/.config/nvim/light_init.vim - '

# コマンドのエイリアス
alias bc='bc -q'
alias info='info --vi-keys'
alias !!='r'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lv='dir -1 -v'
alias lva='dir -1 -v -a'
alias lvd='ls -a | grep "^\." | sed '1,2d''

# シャットダウン及び再起動
alias shutdown='systemctl poweroff'
alias reboot='systemctl reboot'
# ====== エイリアスの設定ここまで ======


# ====== 環境変数及びパスの設定 ======
# 環境変数の設定
export EDITOR=nvim
export CALIBRE_USE_DARK_PALETTE=1
export W3MIMGDISPLAY_PATH=/usr/lib/w3m/w3mimgdisplay

# パスの設定
export PATH=$PATH:/opt/processing-3.5.4/
export PATH=$PATH:/usr/sbin/
export PATH=$PATH:$HOME/.local/bin/
# ====== 環境変数及びパスの設定ここまで ======

# pywalで最後に利用したテーマを呼び出す
cat ~/.cache/wal/sequences
