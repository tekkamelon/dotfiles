#!/bin/sh

set -u

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1
# ====== 変数の設定ここまで ======


# 現在のssidを変数に代入,wi-fiに接続している場合はssidを表示
if command -v iw >/dev/null 2>&1 && ssid_text=$(iw dev | grep -F "ssid"); then

	# ssid_textからssidを抽出
	clean_ssid="${ssid_text#*ssid }"

	# 現在のssidを表示
	printf '<%s>\n' "${clean_ssid}"

# iwコマンドが利用できない場合はnmcliを実行
elif command -v nmcli >/dev/null 2>&1 && ssid_text=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d':' -f2); then

	# nmcliからssidを抽出
	clean_ssid="${ssid_text}"

	# 現在のssidを表示
	printf '<%s>\n' "${clean_ssid}"

else

	printf "<no wireless>\n"

fi

