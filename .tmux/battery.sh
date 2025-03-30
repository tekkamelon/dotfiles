#!/bin/sh

set -eu

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C
export LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1

# BAT0の残量を取得
bat0_status=$(cat /sys/class/power_supply/BAT0/capacity)

# /sys/class/power_supply/BAT1/capacityがあれば真
if [ -e /sys/class/power_supply/BAT1/capacity ]; then

	# BAT1の残量を取得
	bat1_status=$(cat /sys/class/power_supply/BAT1/capacity)

	# BAT0とBAT1の値を表示
	echo "<🔋0:${bat0_status}%/🔋1:${bat1_status}%>"

else

	# BAT0の値のみ表示
	echo "<🔋:${bat0_status}%>"

fi

