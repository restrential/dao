# Translation Workflow

A 4-step pipeline for translating classical Chinese texts into faithful, modern English.

## Overview

Applies to: DDJ, 禮運大同篇, holy teachings, sutras, and any classical Chinese passage.

| Step | Model | Purpose |
|---|---|---|
| 1. Research | **Gemini 2.5 Pro** (+ `google_web_search`) | Identify key/uncommon phrases; trace them to classical stories, koans, parables, allegories, sutras |
| — Gleaned Insights | **Claude Sonnet** | Synthesize research into 3–6 translation-critical decisions before translating |
| 2. Literal | **Claude Sonnet** | Word-for-word, true-to-meaning translation informed by research |
| 3. Smooth | **Claude Sonnet** | Rewrite the literal into natural, modern, culturally appropriate English |
| 4. Review | **Claude Sonnet** | Compare smooth against the original Chinese to verify fidelity; flag any drift |

### Why two models?
- **Gemini** runs `google_web_search` autonomously to look up classical allusions across the open web. This grounds the research in actual sources.
- **Claude** handles the translation craft: nuanced reading of the Chinese, idiomatic English, and fidelity judgments.

### About "Deep Research"
Gemini's *Deep Research* (autonomous multi-step web research) is a Gemini Advanced web-app feature — not directly available in the CLI. What `translate.sh` uses instead is `gemini-2.5-pro` in `--yolo` mode, which auto-approves `google_web_search` calls and iterates freely. For our use case (researching classical Chinese phrases), this is functionally equivalent. For a full Deep Research report on a topic, use [gemini.google.com](https://gemini.google.com) directly.

## Running the Workflow

### Option 1 — `/forge` command (interactive, Claude Code)

```
/forge projects/dao/translation/liji-datong/chinese.md liji-datong
```

Claude orchestrates both phases in-session: calls Gemini for Step 1, then handles
Steps 2–4 directly. Results are written to `output/`.

Translation is currently the primary workflow under `/forge`. The command is designed
to eventually support other research-and-craft workflows (commentary, annotation, etc.).

### Option 2 — Shell script (batch / automated)

```bash
# From homelab root — file input
./projects/dao/translation/translate.sh \
  projects/dao/translation/liji-datong/chinese.md liji-datong

# Inline text via stdin
echo "大道之行也，天下為公。" | \
  ./projects/dao/translation/translate.sh - "liji-datong-opening"
```

Output is saved to `projects/dao/translation/output/TEXTNAME-YYYY-MM-DD.md`.

### When to use which

| Situation | Use |
|---|---|
| Working in Claude Code, want to see/refine output live | `/translate` command |
| Batch processing, cron, or running without Claude Code | `translate.sh` script |

## Output Format

Each run produces a structured markdown file:

```
# [Text Name] — Translation Workspace

**Source:** [reference]
**Date:** YYYY-MM-DD

## Source Text (原文)

[Original Chinese]

---

## Step 1: Research — Key Phrases & Classical Context

### Phrases Identified
| Phrase | Pinyin | Classical Appearances |
|---|---|---|
| ...  | ... | ... |

### Allusion Notes
[For each key phrase: the classical story/sutra/parable that gives it depth]

---

## Step 2: Literal Translation

[Word-for-word rendering with inline annotations]

---

## Step 3: Smoothed Translation

[Natural modern English, applying terminology conventions]

---

## Step 4: Fidelity Review

| Segment | Smoothed | Faithful? | Notes |
|---|---|---|---|
| ... | ... | ✅/⚠️/❌ | ... |

**Overall assessment:** [summary]
**Recommended revisions:** [if any]

---

## Final Translation

[Approved smoothed translation, after incorporating any Step 4 revisions]
```

## Terminology Conventions

See `projects/dao/translation/translation.md` for the full table of established terms (divine titles, roles, practice terms, etc.). The workflow prompt automatically includes all conventions.

### Pinyin

Always use tone-marked pinyin (e.g., `rén`, `dào`, `dé`, `wú wéi`) — never numeric notation (`ren2`, `dao4`).

## Files

| File | Role |
|---|---|
| `workflow.md` | This file — human-readable documentation |
| `step1-research-prompt.md` | Prompt sent to Gemini for Step 1 (phrase research + web search) |
| `workflow-prompt.md` | System prompt sent to Claude for gleaned insights + Steps 2–4 |
| `translate.sh` | Shell script that orchestrates both phases (batch use) |
| `.claude/commands/forge.md` | `/forge` Claude Code command (interactive use) |
| `output/` | Generated translation workspace files |
| `liji-datong/` | 禮運大同篇 project folder |
| `ddj/` | Dao De Jing project folder |
