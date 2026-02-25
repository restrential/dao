# Dao Digitization Project

Preserving and digitizing the temple's physical media archive — audio tapes, video tapes, DVDs/VCDs, audio CDs, and books — for long-term storage, accessibility, and eventual translation.

## Scope

This project currently lives under `projects/dao/` because the immediate need is temple materials. The digitization workflows and agent are designed to be reusable if the scope later expands beyond Dao/temple content.

## Materials to Digitize

### Audio Cassettes
- [ ] Inventory: count and label all tapes
- [ ] Status: not started
- Notes: likely Chinese-language teachings, lectures, or songs

### Video Cassettes (VHS / Betamax / other)
- [ ] Inventory: count and label all tapes
- [ ] Status: not started
- Notes: record label, approximate era, known content if any

### DVD / VCD
- [ ] Inventory: count and catalog
- [ ] Status: not started
- Notes: VCDs are more common in Taiwanese/Chinese contexts — may be a significant portion

### Audio CDs
- [ ] Inventory: count and catalog
- [ ] Status: partially done — some CDs remain
- Notes: may include songs, teachings, or event recordings

### Books / Printed Materials
- [ ] Inventory: identify priority texts for scanning/OCR
- [ ] Status: not started
- Notes: Chinese-language texts will need Traditional Chinese OCR; connect to `projects/dao/translation/` once digitized

---

## Storage

- **Primary:** Synology DS1821+ at `192.168.1.100`
- **Target volume:** `/volume1/` — subfolder TBD (e.g., `/volume1/Tong De Box/Digitization/`)
- **Cloud backup:** Box (Tong De account — `phil@tongde.us`) via Cloud Sync

## File Conventions

### Audio (cassettes, CDs)
- Format: **FLAC** (lossless preservation master); MP3 for distribution copies
- Filename: `YYYYMMDD_{source-type}_{title-slug}_{side-or-track}.flac`
- Example: `20260301_cassette_california-class_sideA.flac`

### Video (VHS, VCD, DVD)
- Capture format: lossless or near-lossless intermediate (e.g., HuffYUV, FFV1, or high-bitrate H.264)
- Archive format: **MKV** container; distribution copy as H.264/H.265 MP4
- Filename: `YYYYMMDD_{source-type}_{title-slug}.mkv`

### Books / Documents (scanned)
- Scan format: **TIFF** at 300–600 DPI (preservation master); PDF/A for distribution
- OCR output: searchable PDF or plain text
- Filename: `{title-slug}_{YYYY}_{pages}.pdf`

---

## Digitization Log

_Log each completed batch here. Detailed logs may be broken into separate files per media type._

| Date | Media Type | Item | Format | Location on NAS | Notes |
|---|---|---|---|---|---|
| — | — | — | — | — | — |

---

## Open Items

- [ ] Audit physical media — full inventory count per type
- [ ] Decide NAS folder structure before first batch
- [ ] Acquire any missing hardware (see digitization-specialist agent for recommendations)
- [ ] Determine whether existing Zoom recording pipeline (Flask/Box) can be reused for any video ingest
- [ ] Establish OCR workflow for Chinese-language books (Document AI aborted 2026-02-25 — evaluate Tesseract or ABBYY as replacement)
- [ ] Connect book OCR output to `projects/dao/translation/` workflow once first text is digitized
