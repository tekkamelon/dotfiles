# Effective Prompts for Gemini CLI Bridge

When invoking Gemini CLI from another agent, the quality of the result depends heavily on the clarity and specificity of the prompt passed to the `--prompt` flag.

## 1. Codebase Analysis Prompts

### High-Level Architectural Overview
```text
Analyze the directory structure and main entry points of this project. Identify the core architectural patterns (e.g., MVC, Hexagonal) and summarize how data flows through the system.
```

### Dependency Mapping
```text
Identify all internal and external dependencies for the module in 'src/auth/'. Create a list of files that would be affected if we changed the authentication provider interface.
```

### Bug Root Cause Analysis
```text
Given the following error log: [paste log], use grep_search to find relevant code sections and identify potential causes for this null pointer exception.
```

## 2. Japanese Language Tasks

### Code Documentation (Japanese)
```text
以下の関数のロジックを解析し、引数、戻り値、例外処理を含めた詳細なJSDocを日本語で作成してください。
対象コード:
[Insert Code Block]
```

### Japanese Commit Message Generation
```text
現在のステージングされた変更（git diff --cached）を分析し、Angularのコミットメッセージ規約に従った、わかりやすい日本語のコミットメッセージを生成してください。
```

### Technical Explanation for Stakeholders
```text
'src/engine/v2/' に実装されている新しい並列処理ロジックについて、非エンジニアでも理解できるような日本語の解説文を作成してください。
```

## 3. Best Practices
- **Explicit Constraints**: Always specify the desired output language (e.g., "Answer in Japanese").
- **Tool Usage Guidance**: If you want Gemini CLI to use specific tools, mention them: "Use grep_search to find all occurrences of...".
- **Context Management**: If the parent agent has already gathered some context, include it in the prompt as a code block to avoid redundant searches.
