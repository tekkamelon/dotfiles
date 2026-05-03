---
name: posix-shell
description: >
  POSIX準拠のシェルスクリプトを書く際に使用するスキル。
  ポータブルなsh/bashスクリプトの作成、移植性の確保、よくある非POSIX構文の回避、
  エラーハンドリング、テスト可能な設計、デバッグ手法などをカバーする。
  「シェルスクリプト」「sh」「bash」「POSIX」「シェル関数」「シェル変数」
  「trap」「getopts」などのキーワードが含まれる場合は必ずこのスキルを参照すること。
  スクリプトを書く・レビューする・デバッグするあらゆる場面で使用する。
---

# POSIX準拠シェルスクリプト作成スキル

## 基本方針

すべてのスクリプトは `/bin/sh` で動作することを前提とする。
Bash固有機能に依存しない書き方を徹底すること。

### シェバン (Shebang)

```sh
#!/bin/sh
# ↑ /bin/bash ではなく /bin/sh を使う
```

bash固有機能を意図的に使う場合のみ `#!/usr/bin/env bash` を許容する。
その場合はスクリプト冒頭に `# requires: bash` とコメントする。

---

## 必須のセーフガード

スクリプトの冒頭に必ず以下を記述する:

```sh
#!/bin/sh
set -eu

# IFS をデフォルト値に明示固定（任意だが推奨）
IFS=$(printf '\n\t')
```

| オプション | 意味 |
|-----------|------|
| `-e` | コマンドが0以外を返したら即終了 |
| `-u` | 未定義変数の参照をエラーにする |
| `-o pipefail` | **bashのみ**。パイプライン中のエラーを捕捉 |

> POSIX shでは `-o pipefail` は使えない。詳細は `references/pipefail-alternatives.md` を参照。

---

## POSIX非準拠な構文（絶対に使わない）

```sh
# NG: bashism 一覧

[[ ... ]]          # → [ ... ] を使う
(( n++ ))          # → n=$((n + 1)) を使う
${var,,}           # → tr '[:upper:]' '[:lower:]' を使う
${var^^}           # → tr '[:lower:]' '[:upper:]' を使う
local var=val      # → local var; var=val に分ける（-eとの相性問題）
echo -e "..."      # → printf を使う
source file        # → . file を使う
function foo() {}  # → foo() {} を使う
>&                 # → 2>&1 など明示的なリダイレクトを使う
read -r -d ''      # → POSIX非準拠。代替手法を使う
```

---

## 変数と引用符

```sh
# 常にダブルクォートで囲む（単語分割・グロブ展開を防ぐ）
echo "$var"
rm -f "$file"

# 空白を含む可能性があるすべての変数展開にクォートが必要
for f in "$@"; do
    echo "$f"
done

# デフォルト値
name="${1:-world}"

# 未定義チェック付きデフォルト値（変数が未定義または空のとき）
val="${VAR:-default}"

# 未定義のときエラーを出して終了（-u より詳細なメッセージ）
: "${REQUIRED_VAR:?REQUIRED_VAR must be set}"
```

---

## 条件分岐

```sh
# [ ] の正しい使い方
[ -z "$var" ]      # 空文字列
[ -n "$var" ]      # 非空文字列
[ "$a" = "$b" ]    # 文字列一致（== はPOSIX非準拠）
[ "$a" != "$b" ]   # 文字列不一致
[ "$n" -eq 0 ]     # 数値比較
[ -f "$file" ]     # ファイルが存在して通常ファイル
[ -d "$dir" ]      # ディレクトリが存在
[ -r "$file" ]     # 読み取り可能
[ -x "$file" ]     # 実行可能

# 複合条件（&& || をシェルレベルで使う）
[ -f "$f" ] && [ -r "$f" ]
```

---

## 関数定義

```sh
# POSIX準拠の関数定義
log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S')" "$*" >&2
}

die() {
    log "ERROR: $*"
    exit 1
}

# localは関数内のみ使用可（ただし初期化は別行にする）
parse_args() {
    local flag
    local value
    flag="$1"
    value="$2"
    # ...
}
```

> `local var=val` の1行初期化は `-e` 環境で右辺のコマンド置換失敗を捕捉できないため、
> 必ず `local var; var=$(cmd)` の2行に分ける。

---

## エラーハンドリングと trap

```sh
#!/bin/sh
set -eu

# 一時ファイルの確実なクリーンアップ
TMPFILE=""

cleanup() {
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
}

trap cleanup EXIT        # 正常・異常問わず終了時に実行
trap 'exit 1' INT TERM   # Ctrl+C やkillで受け取ったとき

TMPFILE=$(mktemp)

# 処理...
```

---

## 引数パース（getopts）

```sh
usage() {
    cat <<EOF
Usage: $(basename "$0") [-v] [-o OUTPUT] FILE...
Options:
  -v          verbose mode
  -o OUTPUT   output file (default: stdout)
  -h          show this help
EOF
}

verbose=0
output=""

while getopts ":vo:h" opt; do
    case "$opt" in
        v) verbose=1 ;;
        o) output="$OPTARG" ;;
        h) usage; exit 0 ;;
        :) die "Option -$OPTARG requires an argument" ;;
        \?) die "Unknown option: -$OPTARG" ;;
    esac
done

shift $((OPTIND - 1))
# $@ がオプション以外の残り引数
```

---

## ヒアドキュメント

```sh
# 標準的なヒアドキュメント
cat <<'EOF'
変数展開しない場合はシングルクォートで囲む
$VAR はそのまま出力される
EOF

# インデント除去（タブのみ。スペースは不可）
cat <<-EOF
	インデントされた内容
	タブが除去される
EOF

# 変数展開あり
cat <<EOF
Hello, $name!
Today is $(date).
EOF
```

---

## テキスト処理のイディオム

```sh
# 文字列の小文字変換（POSIX）
lower=$(printf '%s' "$str" | tr '[:upper:]' '[:lower:]')

# 文字列のトリム（前後の空白除去）
trim() {
    printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# 行数カウント
count=$(wc -l < "$file")

# ファイルの各行を処理
while IFS= read -r line; do
    printf 'Line: %s\n' "$line"
done < "$file"

# コマンド出力の各行を処理（サブシェル問題に注意）
some_command | while IFS= read -r line; do
    # 注意: このwhile内でのvariable変更は外に伝わらない
    printf '%s\n' "$line"
done
```

---

## パス・ファイル操作

```sh
# スクリプト自身のディレクトリを取得
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# ファイル名・拡張子の操作（basename/dirname）
filename=$(basename "$path")          # /a/b/c.txt → c.txt
dir=$(dirname "$path")                # /a/b/c.txt → /a/b
stem=$(basename "$path" .txt)         # /a/b/c.txt → c

# mktemp で安全な一時ファイル
tmp=$(mktemp)
tmpdir=$(mktemp -d)
```

---

## デバッグ

```sh
# 実行トレース（各コマンドを表示）
set -x    # 開始
set +x    # 停止

# またはスクリプト全体をトレース実行
sh -x ./script.sh

# 構文チェックのみ（実行しない）
sh -n ./script.sh

# shellcheck による静的解析（推奨）
shellcheck ./script.sh
```

---

## チェックリスト

スクリプト完成前に以下を確認する:

- [ ] `#!/bin/sh` で始まっているか
- [ ] `set -eu` が冒頭にあるか
- [ ] すべての変数展開がダブルクォートで囲まれているか
- [ ] `[[ ]]` `(( ))` などのbashismを使っていないか
- [ ] `echo` の代わりに `printf` を使っているか
- [ ] `source` の代わりに `.` を使っているか
- [ ] `local var=$(cmd)` を使っていないか（2行に分けているか）
- [ ] 一時ファイルを `trap ... EXIT` で確実に消しているか
- [ ] `shellcheck` をパスするか

---

## 参照ファイル

詳細なリファレンスは以下を参照:

- `references/pipefail-alternatives.md` — pipefailなしでパイプエラーを検出する手法
- `references/portability-table.md` — コマンド・構文のポータビリティ一覧
- `references/common-patterns.md` — よく使うパターン集（ロック、ログ、設定ファイル読み込みなど）
