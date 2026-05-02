# コマンド・構文ポータビリティ一覧

凡例: OK = POSIX準拠 / NG = bash/zsh固有 / 要注意 = 実装依存

## 変数操作

| 書き方 | 意味 | POSIX? | 代替 |
|--------|------|--------|------|
| `${var:-val}` | 未定義または空のときval | OK | — |
| `${var:=val}` | 未定義または空のときvalを代入 | OK | — |
| `${var:?msg}` | 未定義または空のときエラー | OK | — |
| `${var:+val}` | 定義かつ非空のときval | OK | — |
| `${#var}` | 文字列長 | OK | — |
| `${var#pat}` | 前方最短削除 | OK | — |
| `${var##pat}` | 前方最長削除 | OK | — |
| `${var%pat}` | 後方最短削除 | OK | — |
| `${var%%pat}` | 後方最長削除 | OK | — |
| `${var/a/b}` | 最初のaをbに置換 | NG | `echo "$var" \| sed 's/a/b/'` |
| `${var//a/b}` | すべてのaをbに置換 | NG | `echo "$var" \| sed 's/a/b/g'` |
| `${var,,}` | 小文字化 | NG | `printf '%s' "$var" \| tr '[:upper:]' '[:lower:]'` |
| `${var^^}` | 大文字化 | NG | `printf '%s' "$var" \| tr '[:lower:]' '[:upper:]'` |

## 条件式

| 書き方 | 意味 | POSIX? | 代替 |
|--------|------|--------|------|
| `[ ... ]` | テスト | OK | — |
| `[[ ... ]]` | 拡張テスト | NG | `[ ... ]` |
| `[ "$a" = "$b" ]` | 文字列一致 | OK | — |
| `[ "$a" == "$b" ]` | 文字列一致 | NG | `[ "$a" = "$b" ]` |
| `[[ $a =~ regex ]]` | 正規表現マッチ | NG | `printf '%s' "$a" \| grep -E 'regex'` |
| `(( expr ))` | 算術条件 | NG | `[ $((expr)) -ne 0 ]` |

## 算術

| 書き方 | POSIX? | 代替 |
|--------|--------|------|
| `$(( expr ))` | OK | — |
| `(( n++ ))` | NG | `n=$((n + 1))` |
| `let n=n+1` | NG | `n=$((n + 1))` |

## 入出力

| 書き方 | POSIX? | 代替 |
|--------|--------|------|
| `echo "text"` | 要注意 | `printf '%s\n' "text"` |
| `echo -n "text"` | NG | `printf '%s' "text"` |
| `echo -e "a\nb"` | NG | `printf 'a\nb\n'` |
| `read -r line` | OK | — |
| `read -p "prompt" var` | NG | `printf 'prompt'; read -r var` |
| `read -a arr` | NG | パース処理で代替 |

## リダイレクト

| 書き方 | POSIX? | 備考 |
|--------|--------|------|
| `cmd > file` | OK | |
| `cmd >> file` | OK | |
| `cmd 2>&1` | OK | |
| `cmd &> file` | NG | `cmd > file 2>&1` |
| `cmd 2> /dev/null` | OK | |
| `cmd > /dev/null 2>&1` | OK | |

## 配列

POSIXにはスカラー変数とポジショナルパラメータ (`$@`, `$*`) しかない。

| 書き方 | POSIX? | 代替 |
|--------|--------|------|
| `arr=(a b c)` | NG | `set -- a b c` でポジショナルパラメータ活用 |
| `${arr[@]}` | NG | `"$@"` |
| `${#arr[@]}` | NG | `$#` |

## プロセス置換

| 書き方 | POSIX? | 代替 |
|--------|--------|------|
| `<(cmd)` | NG | `mkfifo` か中間ファイル |
| `>(cmd)` | NG | `mkfifo` か中間ファイル |

## その他

| 書き方 | POSIX? | 代替 |
|--------|--------|------|
| `source file` | NG | `. file` |
| `function foo()` | NG | `foo()` |
| `foo() { ... }` | OK | — |
| `$'...'` (ANSIクォート) | NG | `printf` で制御文字を生成 |
| `{1..10}` (ブレース展開) | NG | `seq 1 10` か `while` ループ |
