#!/bin/sh -eu

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

	# 5フィールド目が"IEEE"かつ9フィールド目が"off/any"ではない場合に真
	if($5 == "IEEE" && $9 != "off/any"){

		print "<" $9 ">"

	}else{

		print "<no " "wireless>"

	}

}
'

