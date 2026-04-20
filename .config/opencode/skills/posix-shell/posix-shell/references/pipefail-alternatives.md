# pipefail の代替手法（POSIX sh 向け）

`-o pipefail` は POSIX で規定されておらず、`/bin/sh` では使えない場合がある。
以下に POSIX sh でパイプエラーを検出する手法を示す。

---

## 手法1: 一時ファイルにステータスを書き出す

```sh
tmpfile=$(mktemp)

some_command > "$tmpfile"; status=$?
if [ "$status" -ne 0 ]; then
    die "some_command failed with status $status"
fi
cat "$tmpfile" | next_command
rm -f "$tmpfile"
```

---

## 手法2: パイプを分解して個別実行

```sh
# パイプの代わりに中間ファイルを使う
intermediate=$(mktemp)
step1 > "$intermediate"
step2 < "$intermediate"
rm -f "$intermediate"
```

---

## 手法3: サブシェルでコマンド置換を使う

コマンド置換は失敗時に `-e` で止まる:

```sh
result=$(failing_command | grep pattern)
# failing_command が失敗するとシェルが終了する（-e があれば）
```

ただしパイプの左辺のエラーは `-e` でも捕捉されないことがある点に注意。

---

## 手法4: named pipe (FIFO) を使う

```sh
fifo=$(mktemp -u)
mkfifo "$fifo"
trap 'rm -f "$fifo"' EXIT

producer > "$fifo" &
producer_pid=$!
consumer < "$fifo"

wait "$producer_pid" || die "producer failed"
```

---

## 推奨方針

- 複雑なパイプラインが必要な場合は中間ファイルに分解する
- どうしても `pipefail` が必要なら `#!/usr/bin/env bash` に切り替えを検討する
- `shellcheck` は `#!/bin/sh` のとき `pipefail` の使用を警告してくれる
