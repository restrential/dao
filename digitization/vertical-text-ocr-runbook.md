# Vertical Chinese Text OCR — Runbook

For extracting text from Traditional Chinese PDFs typeset in vertical format (右至左，由上而下).

---

## Which tool to use

| PDF type | Tool |
|---|---|
| **Scanned** (image-based pages) | Google Cloud Document AI — excellent vertical Chinese OCR |
| **Natively digital** (Word-generated, embedded fonts) | `pdfplumber` with coordinate sorting (see below) |

To check: run `pdftotext input.pdf -` and see if readable characters come out. If yes → natively digital. If gibberish → scanned.

`pdftotext` is **not usable** for vertical Chinese regardless of flags:
- Without `-layout`: characters in wrong column order
- With `-layout`: visual-position grid, unusable as plain text

---

## Natively Digital PDFs — pdfplumber Method

### 1. Setup

```bash
python3 -m venv /tmp/pdfenv
/tmp/pdfenv/bin/pip install pdfplumber -q
```

Note: `/tmp` is cleared on reboot — recreate the venv if needed.

### 2. Extraction script

Save as `/tmp/extract_vertical.py`:

```python
import pdfplumber

def extract_vertical_chinese(pdf_path):
    pages_text = []
    with pdfplumber.open(pdf_path) as pdf:
        for page_num, page in enumerate(pdf.pages, 1):
            chars = page.chars
            if not chars:
                pages_text.append(f"[Page {page_num} - no chars]")
                continue

            # Cluster characters into columns by x-position
            col_tolerance = 8  # adjust if columns are very narrow or wide
            columns = {}
            for ch in chars:
                if not ch['text'].strip():
                    continue
                cx = round(ch['x0'] / col_tolerance) * col_tolerance
                if cx not in columns:
                    columns[cx] = []
                columns[cx].append(ch)

            # Sort columns RIGHT to LEFT (descending x = correct reading order)
            sorted_cols = sorted(columns.keys(), reverse=True)

            page_lines = []
            for cx in sorted_cols:
                col_chars = sorted(columns[cx], key=lambda c: c['top'])
                col_text = ''.join(c['text'] for c in col_chars)
                if col_text.strip():
                    page_lines.append(col_text)

            pages_text.append('\n'.join(page_lines))
    return pages_text


pages = extract_vertical_chinese('/tmp/input.pdf')
for i, t in enumerate(pages, 1):
    print(f"=== PAGE {i} ===")
    print(t)
    print()
```

### 3. Run

```bash
# Download the PDF first (if from Mattermost public link):
curl -sL "https://mm.tongde.us/files/..." -o /tmp/input.pdf

/tmp/pdfenv/bin/python3 /tmp/extract_vertical.py
```

---

## Post-Extraction Cleanup

| Issue | Fix |
|---|---|
| Standalone page numbers on their own line | `re.sub(r'(?m)^\d{1,2}$', '', text)` |
| Multi-digit page numbers (10, 11, 12) split across two lines | Same regex handles this |
| Visually similar characters misread (e.g., 消 vs 逍) | Spot-check poem/verse sections against page images |
| Special Dao honorific symbols `〈 〉` dropped | Restore manually from images; use `Φ` as the honorific placeholder: `老Φ` = 老母 (Eternal Mother / 無生老母); `Φ前` = before the Mother; `Φ心` = Mother's heart; `朝Φ顏` = bow to the Mother's face |
| `│` characters (Word layout artifacts) | Remove or replace with comma/nothing |
| Vertical-form punctuation (brackets, parentheses, braces) | Convert to horizontal equivalents — see `sed` command below |
| Sentence-final punctuation starting next column | Normal for vertical→horizontal conversion; no fix needed |

### Vertical-Form Punctuation Normalization

Vertical-layout PDFs encode brackets, parentheses, and braces in their rotated Unicode forms. After extraction, convert all to standard horizontal forms:

| Vertical form | Horizontal form | Name |
|---|---|---|
| `﹁` `﹂` | `「` `」` | Single corner brackets (most common) |
| `﹃` `﹄` | `『` `』` | Double corner brackets |
| `︵` `︶` | `（` `）` | Full-width parentheses |
| `︷` `︸` | `｛` `｝` | Full-width curly braces |
| `︹` `︺` | `〔` `〕` | Lenticular brackets |
| `︻` `︼` | `【` `】` | Black lenticular brackets |

```bash
sed -i '' \
  's/﹁/「/g; s/﹂/」/g; \
   s/﹃/『/g; s/﹄/』/g; \
   s/︵/（/g; s/︶/）/g; \
   s/︷/｛/g; s/︸/｝/g; \
   s/︹/〔/g; s/︺/〕/g; \
   s/︻/【/g; s/︼/】/g' \
  /path/to/output-zh.md
```

---

## Output Convention

- File naming: `{slug}-zh.md` for source text (e.g., `xiu-tian-dao-zh.md`)
- Place in: `projects/dao/translation/{slug}/`
- Include metadata header: title, author, date, source file, encoding note
- Preserve section separators as `＊ ＊ ＊`
- Poem/verse lines: separate couplets with a tab space (`　`) between the two halves

---

## Reference

- First used for: 修天道 (`projects/dao/translation/xiu-tian-dao/`)
- Translation queue: `projects/dao/todo.md`
