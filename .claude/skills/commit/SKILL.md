---
name: commit
description: Generate a conventional commit message from staged changes and commit.
---
 
## Steps
 
1. Run `git diff --staged` to inspect what is staged. If nothing is staged, run `git diff HEAD` and inform the user nothing is staged.
2. Infer the commit type and scope from the diff:
   - **type** — pick one: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`, `perf`, `style`, `build`
   - **scope** — derive from the most specific changed directory or module name (e.g. `src/auth/` → `auth`). Omit scope if changes span many unrelated areas.
3. Write the commit message following these rules:
   - Format: `<type>(<scope>): <summary>` — omit parens if no scope
   - Summary: imperative mood, ≤ 72 chars, no trailing period
   - Body: only include if the *why* is not obvious from the summary. Keep it under 3 lines.
   - Footer: add `BREAKING CHANGE: <description>` if any public API, export, or interface was removed or renamed. Add `Closes #<n>` if the current branch name contains an issue number.
4. Run `git commit -m "<message>"` with the generated message.
5. Print a single confirmation line:
 
```
✔ feat(auth): add OAuth2 token refresh logic
```
 
No other output. Do not explain what you did.
 
## Flags (passed as arguments)
 
| Argument | Behaviour |
|---|---|
| `--dry-run` | Print the proposed message and stop. Do not commit. |
| `--split` | If staged changes touch logically unrelated areas, create multiple commits — one per area — in a sensible order. |
| `--no-scope` | Omit the scope segment regardless of what changed. |
 
## Rules
 
- Never use past tense ("added", "fixed"). Always imperative ("add", "fix").
- Never truncate the summary with "…".
- If the diff is empty or only contains whitespace changes, tell the user and stop.
- If the diff is very large (>500 lines), warn the user and suggest `--split` before proceeding.
- Do not ask clarifying questions unless `--dry-run` was passed.
