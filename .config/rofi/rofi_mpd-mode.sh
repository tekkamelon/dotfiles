#!/bin/bash

set -euCo pipefail

export MPD_HOST=humika.local

function main() {
  # 表示したい項目と実際に実行するコマンドを連想配列として定義する。
  local -Ar menu=(
  	['status']='mpc status && main'
    ['play/pause']='mpc toggle && main'
    ['stop']='mpc stop && main'
    ['previous']='mpc prev && main'
    ['next']='mpc next && main'
    ['repeat ON/OFF']='mpc repeat && main'
    ['random ON/OFF']='mpc random && main'
    ['playlist']='mpc playlist && main'
    ['volume-up']='mpc volume +10 && main'
    ['volume-down']='mpc volume -10 && main'
	['unsetenv']='unset MPD_HOST'
	['localhost']='export MPD_HOST=localhost && main'
  )

  local -r IFS=$'\n'
  # 引数があるなら$1に対応するコマンドを実行する。
  # 引数がないなら連想配列のkeyを表示する。
  [[ $# -ne 0 ]] && eval "${menu[$1]}" || echo "${!menu[*]}"
}

main $@
