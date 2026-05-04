# Command/Syntax Portability Table

Legend: OK = POSIX / NG = Bash/zsh specific / Caution = Implementation dependent

## Variable Operations

| Syntax | Meaning | POSIX? | Alternative |
|--------|---------|--------|-------------|
| `${var:-val}` | val if unset/empty | OK | — |
| `${var:=val}` | Assign val if unset/empty | OK | — |
| `${var:?msg}` | Error if unset/empty | OK | — |
| `${var:+val}` | val if set/non-empty | OK | — |
| `${#var}` | String length | OK | — |
| `${var#pat}` | Shortest prefix remove | OK | — |
| `${var##pat}` | Longest prefix remove | OK | — |
| `${var%pat}` | Shortest suffix remove | OK | — |
| `${var%%pat}` | Longest suffix remove | OK | — |
| `${var/a/b}` | First replace | NG | `echo "$var" \| sed 's/a/b/'` |
| `${var//a/b}` | All replace | NG | `echo "$var" \| sed 's/a/b/g'` |
| `${var,,}` | Lowercase | NG | `printf '%s' "$var" \| tr '[:upper:]' '[:lower:]'` |
| `${var^^}` | Uppercase | NG | `printf '%s' "$var" \| tr '[:lower:]' '[:upper:]'` |

## Conditionals

| Syntax | Meaning | POSIX? | Alternative |
|--------|---------|--------|-------------|
| `[ ... ]` | Test | OK | — |
| `[[ ... ]]` | Extended test | NG | `[ ... ]` |
| `[ "$a" = "$b" ]` | String eq | OK | — |
| `[ "$a" == "$b" ]` | String eq | NG | `[ "$a" = "$b" ]` |
| `[[ $a =~ regex ]]` | Regex match | NG | `printf '%s' "$a" \| grep -E 'regex'` |
| `(( expr ))` | Arithmetic cond | NG | `[ $((expr)) -ne 0 ]` |

## Arithmetic

| Syntax | POSIX? | Alternative |
|--------|--------|-------------|
| `$(( expr ))` | OK | — |
| `(( n++ ))` | NG | `n=$((n + 1))` |
| `let n=n+1` | NG | `n=$((n + 1))` |

## I/O

| Syntax | POSIX? | Alternative |
|--------|--------|-------------|
| `echo "text"` | Caution | `printf '%s\n' "text"` |
| `echo -n "text"` | NG | `printf '%s' "text"` |
| `echo -e "a\nb"` | NG | `printf 'a\nb\n'` |
| `read -r line` | OK | — |
| `read -p "prompt" var` | NG | `printf 'prompt'; read -r var` |
| `read -a arr` | NG | Parse manually |

## Redirects

| Syntax | POSIX? | Notes |
|--------|--------|-------|
| `cmd > file` | OK |  |
| `cmd >> file` | OK |  |
| `cmd 2>&1` | OK |  |
| `cmd &> file` | NG | `cmd > file 2>&1` |
| `cmd 2> /dev/null` | OK |  |
| `cmd > /dev/null 2>&1` | OK |  |

## Arrays

POSIX has only scalar vars and positional params (`$@`, `$*`).

| Syntax | POSIX? | Alternative |
|--------|--------|-------------|
| `arr=(a b c)` | NG | `set -- a b c` use positionals |
| `${arr[@]}` | NG | `"$@"` |
| `${#arr[@]}` | NG | `$#` |

## Process Substitution

| Syntax | POSIX? | Alternative |
|--------|--------|-------------|
| `<(cmd)` | NG | `mkfifo` or temp file |
| `>(cmd)` | NG | `mkfifo` or temp file |

## Others

| Syntax | POSIX? | Alternative |
|--------|--------|-------------|
| `source file` | NG | `. file` |
| `function foo()` | NG | `foo()` |
| `foo() { ... }` | OK | — |
| `$'...'` (ANSI) | NG | `printf` for control chars |
| `{1..10}` (brace exp) | NG | `seq 1 10` or loop |

