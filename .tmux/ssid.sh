#!/bin/sh

set -eu

# ====== 変数の設定 ======
# ロケールの設定
export LC_ALL=C
export LANG=C

# GNU coreutilsの挙動をPOSIXに準拠
export POSIXLY_CORRECT=1
# ====== 変数の設定ここまで ======


iwconfig 2> /dev/null |

# 区切り文字を":"とスペースに指定
awk -F[:" "] '

# 1行目のみを処理
NR == 1{

	# Wi-Fiに接続している場合
	# 6フィールド目が"802.11"かつ9フィールド目が"off/any"ではない場合に真
	if($6 == "802.11" && $9 != "off/any"){

		# ダブルクォートを削除
		gsub("\"" , "" , $9)

		print "<" $9 ">"

	}else{

		print "<no wireless>"

	}

}
'

