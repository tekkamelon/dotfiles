#!/bin/sh

set -eu

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1
# ====== 変数の設定ここまで ======


# バッテリーの有無を確認,あれば真
# BAT0,BAT1の有無を確認,残量を取得
if bat0_status=$(cat /sys/class/power_supply/BAT0/capacity) && bat1_status=$(cat /sys/class/power_supply/BAT1/capacity) ; then

	# BAT0とBAT1の値を表示
	printf '<🔋0:%s%%/🔋1:%s%%>\n' "${bat0_status}" "${bat1_status}"

# BAT0の有無を確認,残量を取得
elif bat0_status=$(cat /sys/class/power_supply/BAT0/capacity) ; then

	# BAT0の値のみ表示
	printf '<🔋:%s%%>\n' "${bat0_status}"

else

	exit 0

fi

