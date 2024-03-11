#!/bin/sh -eu

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C
export LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1

# iwconfigの結果のエラー出力を捨て変数に代入
ssid=$(iwconfig 2> /dev/null)

echo "${ssid}" |

awk 'BEGIN{

	# 区切り文字をダブルクォートに指定
	FS="\""

}

# 1行目のみを処理
NR==1{

	# "IEEE"があれば真,なければ偽
	if(/IEEE/){

		printf "<"$2">\n"

	}else{

		printf "<no wireless>\n"

	}

}'
