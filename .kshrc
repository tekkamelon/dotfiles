# shellcheck disable=SC2148

PS1=$'\E[32m$(hostname -s): ${PWD} $ \E[0m'
# PS1='${LOGNAME}@${HOSTNAME%%.*} $ '

# 各シェル共通の設定を読み込み
. "${HOME}"/.shrc

