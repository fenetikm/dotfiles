---
name: text-proof
description: Proof read a text document
effort: high
---

Read the file provided by the user (or ask which file if none given). Do NOT modify the file. Produce a report only.

## What to check
### Correctness
- Spelling errors, British / Australian English only, NOT US English
- Grammar mistakes (subject-verb agreement, wrong tense, dangling modifiers)
- Punctuation (missing/extra commas, incorrect apostrophes, em vs en dash misuse)
- Capitalisation inconsistencies
- Don't use ampersands except in the names of companies

### Clarity
- Ambiguous pronouns ("it", "this", "they" with unclear referents)
- Overlong sentences (readability)
- Passive voice overuse
- Redundant phrases ("in order to" → "to", "at this point in time" → "now")

### Consistency (within the document itself)
- Terminology — same concept called different names in different sections
- Heading capitalisation style, "Sentence case"
- Number formatting (use words i.e. three when less than 10, numbers when 10 or greater)
- Always use Oxford comma

### Tone and style
- Formality level — is it consistent throughout? Does it shift unexpectedly?
- Hedging language ("maybe", "might", "could possibly") — is it appropriate or evasive?
- Second person consistency ("you" vs "the user" vs "one")
- Jargon that may not suit the intended audience
- Confidence/authority — assertive vs wishy-washy statements
- No weasel phrases

### Markdown-specific (if the file ends in `.md`)
- Broken links (relative paths or obvious dead URLs)
- Code fences missing language tags
- Heading hierarchy (e.g. jumping from H2 to H4)
- Trailing whitespace or hard-wrapped lines that break formatting

### Structure
- Intro/body/conclusion flow — does it land the key point, or is it buried?
- Lists that should be prose, or prose that should be a list
- Missing context (assumes knowledge the reader may not have)

---

## Output Format

The skill should produce a **categorised findings table** rather than inline edits:

| # | Location | Category | Issue | Suggestion |
|---|----------|----------|-------|------------|
| 1 | Line 12 | Spelling | "recieve" | "receive" |
| 2 | Lines 24–26 | Clarity | Sentence is 58 words | Split after "…therefore," |
| 3 | Lines 8, 41 | Consistency | "sign-up" and "signup" used interchangeably | Pick one |

Then a short **summary paragraph** on overall tone and style.

---

The key design principle: the skill is **advisory only** — it never writes to the file unless the user explicitly asks for a second pass to apply specific fixes.
