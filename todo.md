# Dao Project — Todo

Single source of truth for all pending tasks across the Dao project. Sub-project files reference this document rather than maintaining their own open-item lists.

---

## Translation

- [x] **率真進修錄** — source text imported (`translation/lv-zhen-jin-xiu-lu/`); English translation not yet started
- [x] **修天道** — source text imported (`translation/xiu-tian-dao/`); English translation not yet started
- [ ] Continue DDJ translation (`translation/ddj/`)
- [ ] Continue 禮運大同篇 translation (`translation/liji-datong/`)

---

## Digitization

- [ ] Audit physical media — full inventory count per type (cassettes, VHS, VCD/DVD, CDs, books)
- [ ] Decide NAS folder structure before first batch
- [ ] Acquire any missing hardware (consult digitization-specialist agent)
- [ ] Determine whether existing Zoom recording pipeline (Flask/Box) can be reused for any video ingest
- [ ] Establish OCR workflow for Chinese-language books (Document AI aborted 2026-02-25 — evaluate Google Document AI vs. Tesseract vs. ABBYY)
- [ ] Connect book OCR output to `translation/` workflow once first text is digitized

---

## Infrastructure & Tools

- [ ] **Song library streaming** — help tech-illiterate members stream song library; evaluate Synology music server
- [ ] **Knowledge base** — IT knowledge base + translation knowledge base; Notion under consideration
- [ ] **Mattermost** — set up private channel to monitor rare negative press
- [ ] **Meeting recordings** — tooling to analyze speaker dynamics (e.g., interruption counting) on large Chinese-language recording archive

---

## Completed

- [x] 修天道 source text imported and OCR'd (`translation/xiu-tian-dao/`)
- [x] 天然師尊叮嚀心語101則 trilingual import (`translation/tianran-101/`)
- [x] Vertical Chinese OCR runbook written (`digitization/vertical-text-ocr-runbook.md`)
