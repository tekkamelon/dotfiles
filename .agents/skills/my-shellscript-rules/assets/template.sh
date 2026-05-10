#!/bin/sh

# シェルオプションの設定
set -eu

# ====== 変数の宣言 ======
script_name="$(basename "$0")"
input_file=""
needle=""
# ====== 変数の宣言ここまで ======


# ====== 関数の宣言 ======
# 使い方の表示
print_usage() {
    cat <<USAGE_EOF
Usage: ${script_name} -i INPUT_FILE -n NEEDLE

Options:
  -i  入力ファイルの指定
  -n  検索文字列の指定
  -h  ヘルプの表示
USAGE_EOF
}

# エラーメッセージの出力
print_error() {
    printf '%s\n' "$1" >&2
}
# ====== 関数の宣言ここまで ======


# 引数の解析
while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -i)
            if [ "${#}" -lt 2 ]; then

                print_error "引数値の不足"
                print_usage
                exit 1

            fi
            input_file="${2}"
            shift 2
            ;;
        -n)
            if [ "${#}" -lt 2 ]; then

                print_error "引数値の不足"
                print_usage
                exit 1

            fi
            needle="${2}"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            print_error "未知の引数: ${1}"
            print_usage
            exit 1
            ;;
    esac
done

# 必須引数の検証
if [ -z "${input_file}" ] || [ -z "${needle}" ]; then

    print_error "必須引数の不足"
    print_usage
    exit 1

fi

# 入力ファイルの検証
if [ ! -f "${input_file}" ]; then

    print_error "入力ファイルの不在"
    exit 1

fi

# 文字列検索の実行
if grep -F "${needle}" "${input_file}" >/dev/null 2>&1; then

    printf '%s\n' "一致行の存在"

else

    printf '%s\n' "一致行の不在"

fi

# awk処理の実行
awk '
BEGIN { count = 0 }
{ count += 1 }
END { print "line_count=" count }
' "${input_file}"
