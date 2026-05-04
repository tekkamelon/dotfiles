# pipefail Alternatives (POSIX sh)

`-o pipefail` is not POSIX, may not work in `/bin/sh`.
POSIX sh methods to detect pipe errors below.

---

## Method 1: Temp File for Status

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

## Method 2: Break Pipe into Files

```sh
# Use temp file instead of pipe
intermediate=$(mktemp)
step1 > "${intermediate}"
step2 < "${intermediate}"
rm -f "${intermediate}"
```

---

## Method 3: Cmdsub in Subshell

Cmdsub fails under -e:

```sh
result=$(failing_command | grep pattern)
# Shell exits if failing_command fails (-e)
```

Note: Left side pipe errors may not be caught by -e.

---

## Method 4: Named Pipe (FIFO)

```sh
fifo=$(mktemp -u)
mkfifo "${fifo}"
trap 'rm -f "$fifo"' EXIT

producer > "${fifo}" &
producer_pid=$!
consumer < "${fifo}"

wait "${producer_pid}" || die "producer failed"
```

---

## Recommended Approach

- Decompose complex pipelines into temp files
- Consider `#!/usr/bin/env bash` if pipefail essential
- `shellcheck` warns on pipefail in `#!/bin/sh`

