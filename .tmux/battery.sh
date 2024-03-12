#!/bin/sh -eu

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C
export LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1

# バッテリー残量を取得
bat_status=$(cat /sys/class/power_supply/BAT0/capacity)

echo "<BAT0:${bat_status}%>"
