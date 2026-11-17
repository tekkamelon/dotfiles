# Common Patterns

## Lock (Prevent Multiple Instances)

```sh
#!/bin/sh
set -eu

lock_file="/var/run/$(basename "${0}").lock"

# mkdir is atomic, usable as a lock
if ! mkdir "${lock_file}" 2>/dev/null; then
    die "Already running. Lock: ${lock_file}"
fi
trap 'rmdir "${lock_file}"' EXIT

# Process...
```

## Logging (with Timestamp)

```sh
# Single log helper; pass the level as the first argument
log() {
    level="${1}"; shift
    printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S')" "${level}" "${*}" >&2
}

die() {
    log ERROR "${*}"
    exit 1
}

# Usage
log INFO "started"
log WARN "low disk space"
```

## Load Config File

```sh
# config.sh:
#   KEY=value
#   ANOTHER=value

config_file="${1}"
[ -f "${config_file}" ] || die "Config not found: ${config_file}"
# Use . to source (POSIX alt to source)
. "${config_file}"
```

## Check Dependencies

```sh
for cmd in curl jq awk sed; do
    command -v "${cmd}" > /dev/null 2>&1 || \
        die "Required command not found: ${cmd}"
done
```

## Retry Logic

```sh
# Reusable helper for commands retried from multiple call sites
retry() {
    max_attempts="${1}"; shift
    delay="${2}"; shift
    attempt=1

    while [ "${attempt}" -le "${max_attempts}" ]; do
        if "${@}"; then
            return 0
        fi
        log WARN "Attempt ${attempt}/${max_attempts} failed. Retrying in ${delay}s..."
        sleep "${delay}"
        attempt=$((attempt + 1))
    done

    die "All ${max_attempts} attempts failed: ${*}"
}

retry 3 5 curl -sf "https://example.com/api"
```

## Numeric Validation

```sh
is_integer() {
    case "${1}" in
        ''|*[!0-9]*) return 1 ;;
        *) return 0 ;;
    esac
}

is_positive_integer() {
    is_integer "${1}" && [ "${1}" -gt 0 ]
}
```

## To Absolute Path

```sh
to_absolute() {
    path="${1}"
    case "${path}" in
        /*) printf '%s\n' "${path}" ;;
        *)  printf '%s/%s\n' "$(pwd)" "${path}" ;;
    esac
}
```

## Environment Variable Validation Template

```sh
#!/bin/sh
set -eu

: "${DB_HOST:?DB_HOST is required}"
: "${DB_PORT:?DB_PORT is required}"
: "${DB_NAME:?DB_NAME is required}"

is_integer "${DB_PORT}" || die "DB_PORT must be an integer: ${DB_PORT}"
[ "${DB_PORT}" -ge 1 ] && [ "${DB_PORT}" -le 65535 ] || \
    die "DB_PORT out of range: ${DB_PORT}"
```

## Parallel File Processing (with wait)

```sh
# Track background PIDs
pids=""

for file in "${@}"; do
    process_file "${file}" &
    pids="${pids} $!"
done

# Unquoted ${pids} is intentional word splitting
failed=0
for pid in ${pids}; do
    wait "${pid}" || failed=$((failed + 1))
done

[ "${failed}" -eq 0 ] || die "${failed} jobs failed"
```
