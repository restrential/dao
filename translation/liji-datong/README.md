# 禮運大同篇

**Full title:** 禮運大同篇 (Lǐ Yùn Dà Tóng Piān — "The Great Harmony")
**Source:** 禮記·禮運第九 (*Liji*, Book of Rites, Chapter 9 — Lǐ Yùn)
**Reference:** [孔教學院 (Confucian Academy)](https://www.confucianacademy.com/load.php?link_id=27616)

## About the Text

A single passage from the *Liji* (禮記, *Book of Rites*), one of the Five Confucian Classics.
Describes Confucius's vision of 大同 (Dàtóng) — Great Harmony or Great Unity —
a society governed by universal virtue rather than kinship or private ownership.
One of the most cited passages in Chinese political and spiritual philosophy.

## Translation Goals

- Faithful to the Confucian vision of 大同 as a moral, not merely political, ideal
- Apply terminology conventions from `../translation.md`
- Accessible to Western readers without footnotes; poetic where the original is poetic

## Files

| File | Contents |
|---|---|
| `chinese.md` | Original Traditional Chinese text with source attribution |
| `translation.md` | All pipeline stages: research → gleaned insights → literal → smooth → review → final |

## Translation Pipeline

This text is translated using the two-phase workflow defined in `../workflow.md`:

1. **Gemini 2.5 Pro** (`google_web_search` enabled) — researches key phrases against classical sources
2. **Claude Sonnet** — synthesizes gleaned insights, produces literal and smoothed translations, runs fidelity review

To generate or update the translation:

```bash
# From the homelab root:
./projects/dao/translation/translate.sh \
  projects/dao/translation/liji-datong/chinese.md \
  liji-datong

# Or within Claude Code:
/forge projects/dao/translation/liji-datong/chinese.md
```

Output is written to `../output/liji-datong-YYYY-MM-DD.md`, then reviewed and promoted into `translation.md` manually.
