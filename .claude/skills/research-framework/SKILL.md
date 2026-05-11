---
name: research-framework
description: Use when the user asks you to research, evaluate, or compare a programming framework, library, or runtime. Triggers on "research X", "tell me about X framework", "should I use X", "compare X and Y frameworks", "evaluate X".
effort: high
---

# Framework Research

You are conducting a structured technical evaluation of: **$ARGUMENTS**

Run all web searches in parallel where possible. Produce a report under the headings below. Be precise and dry — no marketing language. Include concrete data (dates, numbers, GitHub stats) wherever possible.

---

## Research Steps

### 1. Identity and Language
Search: `"$ARGUMENTS" framework language site:github.com OR site:npmjs.com OR site:pypi.org OR site:pkg.go.dev`
- Primary language(s)
- Language version requirements / constraints
- Typing: static / dynamic / optional

### 2. Age and Maintenance Health
Search: `"$ARGUMENTS" framework changelog releases latest`
Also check: GitHub repo — last commit, release cadence, open vs closed issues ratio, contributor count
- First release date
- Latest stable version + date
- Release cadence (weekly / monthly / sporadic)
- Commit activity last 6 months
- Is there a funded org, CNCF/Apache/Linux Foundation backing, or solo maintainer?
- Any known deprecation or end-of-life signals?

### 3. Architecture
Search: `"$ARGUMENTS" framework architecture internals design`
- Core design pattern (MVC, actor model, event loop, etc.)
- Sync vs async / concurrency model; for Go: note goroutine/channel usage, context propagation patterns
- Extension points: plugins, middleware, hooks
- Monolith vs modular / batteries-included vs minimal
- Notable design trade-offs

### 4. Adoption and Community
Search: `"$ARGUMENTS" framework popularity survey latest` and check Stack Overflow Developer Survey, State of JS/Python/etc.
- GitHub stars + forks (note trajectory, not just total)
- npm/PyPI/pkg weekly downloads if applicable; for Go: check pkg.go.dev import count and proxy.golang.org stats
- Stack Overflow tag question count
- Mentions in industry surveys (e.g. State of JS, JetBrains survey)
- Notable production users (logos page, case studies)
- Community size: Discord/Slack members, subreddit subscribers

### 5. Dependencies
Search: `"$ARGUMENTS" framework dependencies security vulnerabilities`
- Direct dependency count (check package.json / pyproject.toml / go.mod); for Go: note whether it uses Go modules, check go.sum for transitive dep count
- Known heavy or controversial transitive deps
- Supply-chain risk signals: CVE history, abandoned sub-deps
- Bundle size if frontend

### 6. Alternatives
Search: `"$ARGUMENTS" vs [top alternatives] comparison latest`
Identify 3–5 direct alternatives and build a comparison matrix:

| Dimension | $ARGUMENTS | Alt 1 | Alt 2 | Alt 3 |
|---|---|---|---|---|
| Language | | | | |
| Age | | | | |
| Stars | | | | |
| Perf (relative) | | | | |
| Learning curve | | | | |
| Best fit | | | | |

---

## Output Format

Structure your report with these exact sections:

```
## $ARGUMENTS — Framework Evaluation

### TL;DR
2–3 sentence verdict: what it's good for, what it's bad for, who should use it.

### Language & Runtime
...

### Age & Maintenance
...

### Architecture
...

### Adoption
...

### Dependencies & Risk
...

### Alternatives
[matrix table]

### Recommendation
When to choose $ARGUMENTS over alternatives. Concrete use-case fit.

### Sources
- [title](url)
- ...
```

---

## Quality Rules

- Cite sources. Every factual claim (stat, date, quote) gets a URL.
- Use numbers. "2.1M weekly downloads" beats "popular".
- Flag uncertainty. If you can't find data for a dimension, say so rather than speculating.
- Avoid vendor docs as the sole source for adoption/maintenance claims — cross-check with neutral sources.
- If $ARGUMENTS is ambiguous (e.g. "Express" could mean Express.js or something else), clarify before researching.
