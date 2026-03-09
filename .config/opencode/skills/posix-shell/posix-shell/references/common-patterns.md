# よく使うパターン集

## ロック（多重起動防止）

```sh
#!/bin/sh
set -eu

LOCKFILE="/var/run/$(basename "$0").lock"

acquire_lock() {
    # mkdir はアトミックなのでロックに使える
    if ! mkdir "$LOCKFILE" 2>/dev/null; then
        die "Already running. Lock: $LOCKFILE"
    fi
    trap 'rmdir "$LOCKFILE"' EXIT
}

acquire_lock
# 処理...
```

## ログ出力（タイムスタンプ付き）

```sh
LOG_LEVEL="${LOG_LEVEL:-INFO}"

log() {
    level="$1"; shift
    printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S')" "$level" "$*" >&2
}

log_info()  { log INFO  "$@"; }
log_warn()  { log WARN  "$@"; }
log_error() { log ERROR "$@"; }
die()       { log_error "$@"; exit 1; }
```

## 設定ファイルの読み込み

```sh
# config.sh:
#   KEY=value
#   ANOTHER=value

load_config() {
    config_file="$1"
    [ -f "$config_file" ] || die "Config not found: $config_file"
    # . でファイルを読み込む（sourceのPOSIX代替）
    . "$config_file"
}
```

## 依存コマンドの確認

```sh
require_commands() {
    for cmd in "$@"; do
        command -v "$cmd" > /dev/null 2>&1 || \
            die "Required command not found: $cmd"
    done
}

require_commands curl jq awk sed
```

## リトライ処理

```sh
retry() {
    max_attempts="$1"; shift
    delay="$2"; shift
    attempt=1

    while [ "$attempt" -le "$max_attempts" ]; do
        if "$@"; then
            return 0
        fi
        log_warn "Attempt $attempt/$max_attempts failed. Retrying in ${delay}s..."
        sleep "$delay"
        attempt=$((attempt + 1))
    done

    die "All $max_attempts attempts failed: $*"
}

retry 3 5 curl -sf "https://example.com/api"
```

## 数値バリデーション

```sh
is_integer() {
    case "$1" in
        ''|*[!0-9]*) return 1 ;;
        *) return 0 ;;
    esac
}

is_positive_integer() {
    is_integer "$1" && [ "$1" -gt 0 ]
}
```

## 絶対パスへの変換

```sh
to_absolute() {
    path="$1"
    case "$path" in
        /*) printf '%s\n' "$path" ;;
        *)  printf '%s/%s\n' "$(pwd)" "$path" ;;
    esac
}
```

## 進捗表示（シンプルなスピナー）

```sh
spinner() {
    pid=$1
    i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i + 1) % 4 ))
        case "$i" in
            0) c='|' ;; 1) c='/' ;; 2) c='-' ;; 3) c='\' ;;
        esac
        printf '\r%s Working...' "$c" >&2
        sleep 0.1
    done
    printf '\r' >&2
}

long_running_command &
spinner $!
wait $!
```

## 環境変数の検証テンプレート

```sh
#!/bin/sh
set -eu

: "${DB_HOST:?DB_HOST is required}"
: "${DB_PORT:?DB_PORT is required}"
: "${DB_NAME:?DB_NAME is required}"

is_integer "$DB_PORT" || die "DB_PORT must be an integer: $DB_PORT"
[ "$DB_PORT" -ge 1 ] && [ "$DB_PORT" -le 65535 ] || \
    die "DB_PORT out of range: $DB_PORT"
```

## 複数ファイルへの並列処理（waitを使う）

```sh
# バックグラウンドジョブのPIDを追跡
pids=""

for file in "$@"; do
    process_file "$file" &
    pids="$pids $!"
done

failed=0
for pid in $pids; do
    wait "$pid" || failed=$((failed + 1))
done

[ "$failed" -eq 0 ] || die "$failed jobs failed"
```
