---
name: my-shellscript-rules
description: >
  Personal shell scripting conventions focused on POSIX portability,
  readability, and consistent style. Use this skill when writing shell scripts.
---

# my-shellscript-rules

## Purpose

This skill captures my practical conventions for writing shell scripts.
Use these rules to keep scripts portable, readable, and maintainable.

## Scope

- Target POSIX-compatible shell scripting unless explicitly instructed otherwise.
- Prefer broadly available tools and options.

## Command Usage Rules

### grep

- When regular expressions are not required, use fixed-string matching.
- Prefer grep -F for literal search.

Example:

```sh
grep -F "${needle}" "${file_path}"
```

### awk

- Write awk programs that run on mawk.
- Do not rely on GNU awk-only extensions.
- Keep awk syntax conservative and portable.

## Argument Parsing Rules

- Do not use `getopts` in my scripts.
- Parse arguments with a loop such as `while [ "${#}" -gt 0 ]; do`.
- Handle options with `case` and advance with `shift`.
- Validate missing option values explicitly.

Example:

```sh
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
```

## Variable Rules

- Always wrap expansions with double quotes and braces.
  - Good: "${value}"
  - Avoid: $value (unless strict shell syntax requires it)
- Environment variables: uppercase snake_case.
- Normal variables: lowercase snake_case.

Example:

```sh
PATH_INPUT="${PATH_INPUT}"
file_path="/tmp/example.txt"
printf '%s\n' "${file_path}"
```

## Readability Rules

- Structure code so it can be read naturally from left to right, top to bottom.
- Avoid unnecessary function declarations.
  - Too many helper functions can reduce linear readability.
- Write code that is easy for humans to scan and understand quickly.
- Insert line breaks appropriately in if, case, and similar control structures.
- Insert blank lines between logical blocks.

### Section Markers

Use explicit section markers so readers can quickly identify boundaries.
Apply the same idea to function and variable blocks.

```sh
# ====== 関数の宣言 ======
# ...
# ====== 関数の宣言ここまで ======

# ====== 変数の宣言 ======
# ...
# ====== 変数の宣言ここまで ======
```

## Comment Rules

- Write comments in Japanese.
- Use noun-phrase style (体言止め).
- Keep comments concise and descriptive.

Good:

```sh
# 文字列を出力
```

Avoid:

```sh
# 文字列を出力する
```

## Quick Checklist

- [ ] grep -F used for literal matching.
- [ ] awk code compatible with mawk (no gawk-specific features).
- [ ] Arguments parsed with `while [ "${#}" -gt 0 ]` + `case` + `shift`.
- [ ] `getopts` not used.
- [ ] Variable expansions written as "${name}".
- [ ] Variable naming follows snake_case rules.
- [ ] Control structures are spaced and line-broken for readability.
- [ ] Logical blocks separated by blank lines.
- [ ] Section marker comments inserted where helpful.
- [ ] Comments are Japanese noun phrases.