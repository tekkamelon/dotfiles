#!/bin/sh

acpi | 

awk 'BEGIN{

	# 区切り文字を","と":"に指定
	FS="[,|:]"

	OFS = " "


}

{

	# スペースの削除
	gsub(" " , "")

	print "<"$2,$3">"

}'
