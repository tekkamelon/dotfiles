#!/bin/sh
# webラジオを検索し,mpdのキューに追加するスクリプト
# 使用例: search_and_add.sh "jazz" "localhost"

QUERY="${1:-}"
HOST="${2:-localhost}"

# 検索ワードが空の場合は終了
if [ -z "${QUERY}" ]; then
    echo "検索ワードを指定してください" >&2
    exit 1
fi

# URLを検索 (先頭1件を使用)
url=$(radio-browser-cli search --name "${QUERY}" --format urls | head -n 1)

# URLが取得できなかった場合は終了
if [ -z "${url}" ]; then
    echo "ラジオ局が見つかりませんでした" >&2
    exit 1
fi

# MPDのキューに追加
mpc --host="${HOST}" add "${url}"

echo "キューに追加しました: ${url}"

# キューに追加後再生
mpc --host="${HOST}" playlist |

# キューに追加した曲を再生
grep -n . | tail -n 1 | cut -d: -f1 | xargs -I{} mpc --host="${HOST}" play {}
