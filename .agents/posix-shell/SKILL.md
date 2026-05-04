---
name: posix-shell
description: >
  Skill for writing POSIX-compliant shell scripts.
  Covers portable sh/bash script creation, ensuring portability, avoiding common non-POSIX syntax,
  error handling, testable design, debugging techniques, etc.
  Always refer to this skill when keywords like "shell script", "sh", "bash", "POSIX", "shell functions", "shell variables",
  "trap", "getopts" are included.
  Use in all scenarios for writing, reviewing, and debugging scripts.
---

# POSIX-Compliant Shell Scripting Skill

## Basic Policy

All scripts assume execution under `/bin/sh`.
Strictly avoid Bash-specific features.

### Shebang

```sh
#!/bin/sh
# ↑ Use /bin/sh, not /bin/bash
```

Only allow `#!/usr/bin/env bash` when intentionally using Bash-specific features.
In that case, add `# requires: bash` comment at the top.

---

## Essential Safeguards

Always include the following at the script beginning:

```sh
#!/bin/sh
set -eu

# Explicitly set IFS to default (optional but recommended)
IFS=$(printf '\n\t')
```

| Option | Meaning |
|--------|---------|
| `-e`  | Exit if command returns non-zero |
| `-u`  | Error on unset variable reference |
| `-o pipefail` | **Bash only**. Catch pipeline errors |

> POSIX sh does not support `-o pipefail`. See `references/pipefail-alternatives.md`.

---

## Non-POSIX Syntax (Never Use)

```sh
# NG: bashisms list

[[ ... ]]         # → Use [ ... ]
(( n++ ))         # → Use n=$((n + 1))
${var,,}          # → Use tr '[:upper:]' '[:lower:]'
${var^^}          # → Use tr '[:lower:]' '[:upper:]'
local var=val     # → Split to local var; var=val (compatibility with -e)
echo -e "..."     # → Use printf
source file       # → Use . file
function foo() {} # → Use foo() {}
>&                # → Explicit redirect like 2>&1
read -r -d ''     # → Non-POSIX. Use alternatives
```

---

## Variables and Quotes

```sh
# Always double-quote (prevents word splitting/glob expansion)
echo "$var"
rm -f "$file"

# Quote all variable expansions that may contain spaces
for f in "$@"; do
    echo "$f"
done

# Default value
name="${1:-world}"

# Default if unset or empty
val="${VAR:-default}"

# Error if unset or empty
: "${REQUIRED_VAR:?REQUIRED_VAR must be set}"
```

---

## Conditionals

```sh
# Correct [ ] usage
[ -z "$var" ]     # Empty string
[ -n "$var" ]     # Non-empty
[ "$a" = "$b" ]   # String equal (== non-POSIX)
[ "$a" != "$b" ]  # String not equal
[ "$n" -eq 0 ]    # Numeric eq
[ -f "$file" ]    # Regular file exists
[ -d "$dir" ]     # Directory exists
[ -r "$file" ]    # Readable
[ -x "$file" ]    # Executable

# Compound (use shell-level && || )
[ -f "$f" ] && [ -r "$f" ]
```

---

## Function Definitions

```sh
# POSIX-compliant function
log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S')" "$*" >&2
}

die() {
    log "ERROR: $*"
    exit 1
}

# local only inside functions (init on separate line)
parse_args() {
    local flag
    local value
    flag="$1"
    value="$2"
    # ...
}
```

> `local var=val` single-line init fails to catch cmdsub errors under -e.
> Always split: `local var; var=$(cmd)`

---

## Error Handling and trap

```sh
#!/bin/sh
set -eu

# Reliable temp file cleanup
TMPFILE=""

cleanup() {
    [ -n "$TMPFILE" ] && rm -f "$TMPFILE"
}

trap cleanup EXIT        # Run on normal/abnormal exit
trap 'exit 1' INT TERM   # On Ctrl+C or kill

TMPFILE=$(mktemp)

# Process...
```

---

## Argument Parsing (getopts)

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
# $@ now positional args after options
```

---

## Here Documents

```sh
# Standard here-doc
cat <<'EOF'
No variable expansion with single quotes
$VAR printed as-is
EOF

# Indent removal (tabs only, spaces no)
cat <<-EOF
	Indented content
	Tabs stripped
EOF

# With expansion
cat <<EOF
Hello, $name!
Today is $(date).
EOF
```

---

## Text Processing Idioms

```sh
# To lowercase (POSIX)
lower=$(printf '%s' "$str" | tr '[:upper:]' '[:lower:]')

# Trim leading/trailing whitespace
trim() {
    printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Line count
count=$(wc -l < "$file")

# Process each line
while IFS= read -r line; do
    printf 'Line: %s\n' "$line"
done < "$file"

# Process command output lines (note subshell issue)
some_command | while IFS= read -r line; do
    # Changes inside while don't propagate out
    printf '%s\n' "$line"
done
```

---

## Path/File Operations

```sh
# Script dir
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# basename/dirname
filename=$(basename "$path")          # /a/b/c.txt → c.txt
dir=$(dirname "$path")                # /a/b/c.txt → /a/b
stem=$(basename "$path" .txt)         # /a/b/c.txt → c

# Safe temp files
tmp=$(mktemp)
tmpdir=$(mktemp -d)
```

---

## Variable Expansion

**Always** expand variables with double-quotes and braces: `"${var_name}"`.
Never use bare `$var`, `"$var"`, or `${var}` without surrounding double-quotes.

```sh
# OK
echo "${message}"
cp "${src_file}" "${dest_dir}/"
log_file="${output_dir}/app.log"

# NG — do not use these forms
echo $message          # no quotes, no braces
echo "$message"        # quotes but no braces
echo ${message}        # braces but no quotes
```

This rule applies to:
- All variable references in commands and arguments
- Variable assignments on the right-hand side (`dst="${base_dir}/sub"`)
- Parameter expansions (`"${1:-default}"`, `"${var%.*}"`)
- Command substitutions inside strings (`"${output_dir}/$(date +%Y%m%d)"`)

Exception: variables inside `$(( ))` arithmetic expressions do not require quotes or braces.
## Debugging

```sh
# Trace execution
set -x    # Start
set +x    # Stop

# Or trace whole script
sh -x ./script.sh

# Syntax check only
sh -n ./script.sh

# shellcheck static analysis (recommended)
shellcheck ./script.sh
```

---

## Checklist

Before completion, verify:

- [ ] Starts with `#!/bin/sh`
- [ ] Has `set -eu` early
- [ ] All var expansions double-quoted
- [ ] No bashisms like `[[ ]] (( ))`
- [ ] Uses `printf` not `echo`
- [ ] Uses `.` not `source`
- [ ] No `local var=$(cmd)` (split lines)
- [ ] Temp files cleaned by `trap ... EXIT`
- [ ] Passes `shellcheck`

---

## References

- `references/pipefail-alternatives.md` — Pipeline error detection without pipefail
- `references/portability-table.md` — Command/syntax portability table
- `references/common-patterns.md` — Common patterns (locks, logging, config loading, etc.)
