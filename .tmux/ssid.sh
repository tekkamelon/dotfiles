#!/bin/sh

set -eu

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1
# ====== 変数の設定ここまで ======

# 現在のssidを変数に代入,wi-fiに接続している場合はssidを表示
if ssid_text=$(iwgetid -r) && [ -n "${ssid_text}" ]; then

	# 現在のssidを表示
	printf '<%s>\n' "${ssid_text}"

else

	printf "<no wireless>\n"

fi

