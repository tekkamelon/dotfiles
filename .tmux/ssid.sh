#!/bin/sh

set -u

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C
export LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1
# ====== 変数の設定ここまで ======


# 現在のssidを変数に代入,wi-fiに接続している場合はssidが表示される
ssid_text=$(iw dev | grep -F "ssid")

# ssid_textからssidを抽出
clean_ssid="${ssid_text#*ssid }"

# ssid_textがあれば真
if [ -n "${ssid_text}" ] ; then

	# 現在のssidを表示
	printf '<%s>\n' "${clean_ssid}"

else

	printf "<no wireless>\n"

fi

