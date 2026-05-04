---
name: gemini-cli-bridge
description: >
  Use this skill to invoke Gemini CLI for advanced codebase analysis,
  information gathering, and high-quality Japanese language tasks from
  other coding agents. Keywords: gemini-cli, Japanese, analysis, headless.
---

# Gemini CLI Bridge Skill

## Overview
This skill provides instructions on how to use Gemini CLI as a powerful tool for information gathering and Japanese language processing from within another agent's environment.

## When to Use
- When you need to perform complex searches or analysis across a large codebase.
- When high-precision Japanese language understanding or generation is required.
- When you need to gather information using Gemini CLI's specialized tools.

## Procedure
1.  **Non-Interactive Execution**: Use the `--prompt` (or `-p`) flag to run Gemini CLI in headless mode.
2.  **Read-Only Mode**: For information gathering without modifying the filesystem, use `--approval-mode plan`.
3.  **Command Template**:
    ```bash
    gemini --prompt "Your detailed instructions here" --approval-mode plan
    ```
4.  **Handling Context**: Pass specific file paths or directories using `--include-directories` if they are outside the current workspace.

## Examples

### Codebase Investigation (Read-Only)
```bash
gemini --prompt "Search for all instances of 'auth-provider' and summarize their usage." --approval-mode plan
```

### Japanese Language Task
```bash
gemini --prompt "以下のソースコードのロジックを日本語で詳しく解説してください。" --approval-mode plan
```

## Checklist
- [ ] Is `gemini-cli` installed and accessible in the PATH?
- [ ] Is the prompt clear and specific?
- [ ] For non-modifying tasks, is `--approval-mode plan` used?

## References
- Effective Prompts: [prompts.md](references/prompts.md)
- Gemini CLI Documentation: https://geminicli.com