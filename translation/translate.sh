#!/usr/bin/env bash
# translate.sh — 4-step classical Chinese translation workflow
#
# Phase 1 (Gemini 2.5 Pro + google_web_search): research key phrases
# Phase 2 (Claude Sonnet): literal translation, smoothing, fidelity review
#
# Usage:
#   ./translate.sh <input-file> [output-name]
#   echo "大道之行也..." | ./translate.sh - [output-name]
#
# Output: projects/dao/translation/output/OUTPUT_NAME-YYYY-MM-DD.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESEARCH_PROMPT_FILE="$SCRIPT_DIR/step1-research-prompt.md"
TRANSLATE_PROMPT_FILE="$SCRIPT_DIR/workflow-prompt.md"
OUTPUT_DIR="$SCRIPT_DIR/output"

INPUT_ARG="${1:-}"
OUTPUT_NAME="${2:-}"

# --- Validate ---
if [[ -z "$INPUT_ARG" ]]; then
  echo "Usage: $0 <input-file | -> [output-name]" >&2
  echo "  Use '-' to read from stdin." >&2
  exit 1
fi

for f in "$RESEARCH_PROMPT_FILE" "$TRANSLATE_PROMPT_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: Required prompt file not found: $f" >&2
    exit 1
  fi
done

# --- Read input text ---
if [[ "$INPUT_ARG" == "-" ]]; then
  INPUT_TEXT=$(cat)
  [[ -z "$OUTPUT_NAME" ]] && OUTPUT_NAME="translation"
else
  if [[ ! -f "$INPUT_ARG" ]]; then
    echo "Error: Input file '$INPUT_ARG' not found." >&2
    exit 1
  fi
  INPUT_TEXT=$(cat "$INPUT_ARG")
  if [[ -z "$OUTPUT_NAME" ]]; then
    OUTPUT_NAME=$(basename "$INPUT_ARG" | sed 's/\.[^.]*$//')
  fi
fi

if [[ -z "$INPUT_TEXT" ]]; then
  echo "Error: Input text is empty." >&2
  exit 1
fi

# --- Prepare output ---
DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="$OUTPUT_DIR/${OUTPUT_NAME}-${DATE}.md"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT
STEP1_FILE="$TEMP_DIR/step1-research.md"

mkdir -p "$OUTPUT_DIR"

# ─────────────────────────────────────────────────────────
# PHASE 1: Gemini 2.5 Pro — research key phrases (Step 1)
# ─────────────────────────────────────────────────────────
echo "=== Phase 1: Gemini — Step 1 Research ===" >&2

RESEARCH_PROMPT="$(cat "$RESEARCH_PROMPT_FILE")

$(printf '%s' "$INPUT_TEXT")"

gemini \
  -m gemini-2.5-pro \
  -p "$RESEARCH_PROMPT" \
  --yolo \
  > "$STEP1_FILE"

echo "  Step 1 complete ($(wc -l < "$STEP1_FILE") lines)" >&2

# ─────────────────────────────────────────────────────────
# PHASE 2: Claude — Steps 2–4 (literal, smooth, review)
# ─────────────────────────────────────────────────────────
echo "=== Phase 2: Claude — Steps 2–4 ===" >&2

STEP1_OUTPUT=$(cat "$STEP1_FILE")
SYSTEM_PROMPT=$(cat "$TRANSLATE_PROMPT_FILE")

USER_PROMPT="Translate the following classical Chinese text using Steps 2–4 of the workflow. Output name: ${OUTPUT_NAME}.

## Original Chinese Text (原文)

$(printf '%s' "$INPUT_TEXT")

---

## Step 1 Research (from Gemini)

$(printf '%s' "$STEP1_OUTPUT")"

claude \
  -p "$USER_PROMPT" \
  --system-prompt "$SYSTEM_PROMPT" \
  --model claude-sonnet-4-6 \
  > "$TEMP_DIR/steps234.md"

echo "  Steps 2–4 complete ($(wc -l < "$TEMP_DIR/steps234.md") lines)" >&2

# ─────────────────────────────────────────────────────────
# ASSEMBLE: combine into final output file
# ─────────────────────────────────────────────────────────
# Note: steps234 output already contains Research Summary, Steps 2–4, and Final Translation
# Assemble: header + source + step1 (Gemini) + steps2-4+gleaned (Claude)
{
  printf '# %s — Translation Workspace\n\n' "${OUTPUT_NAME}"
  printf '**Date:** %s\n\n' "${DATE}"
  printf '## Source Text (原文)\n\n'
  printf '%s\n\n' "$INPUT_TEXT"
  printf -- '---\n\n'
  cat "$STEP1_FILE"
  printf '\n\n---\n\n'
  cat "$TEMP_DIR/steps234.md"
} > "$OUTPUT_FILE"

echo >&2
echo "Done. Output saved to:" >&2
echo "  $OUTPUT_FILE" >&2
