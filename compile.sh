#!/usr/bin/env bash
set -euo pipefail

# Simple LaTeX compile helper for guide_aim_training.tex
# - Prefer latexmk when available (handles bibtex/biber automatically)
# - Fallback to pdflatex + bibtex sequence

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

TEXFILE="guide_aim_training.tex"
BASE="${TEXFILE%.tex}"

echo "Compiling $TEXFILE in $ROOT_DIR"

if command -v latexmk >/dev/null 2>&1; then
  echo "Using latexmk (pdf)"
  latexmk -pdf -interaction=nonstopmode -halt-on-error "$TEXFILE"
  echo "latexmk finished. Cleaning auxiliary files..."
  latexmk -c
else
  echo "latexmk not found — falling back to pdflatex + bibtex sequence"
  pdflatex -interaction=nonstopmode "$TEXFILE"
  bibtex "$BASE"
  pdflatex -interaction=nonstopmode "$TEXFILE"
  pdflatex -interaction=nonstopmode "$TEXFILE"
fi

if [ -f "${BASE}.pdf" ]; then
  echo "Compilation réussie : ${ROOT_DIR}/${BASE}.pdf"
  exit 0
else
  echo "Erreur : le PDF n'a pas été produit." >&2
  exit 2
fi
#!/bin/bash

# Compile le document
pdflatex -interaction=batchmode guide_aim_training.tex
pdflatex -interaction=batchmode guide_aim_training.tex

# Nettoie les fichiers temporaires
rm -f *.aux *.log *.out *.toc *.nav *.snm

# Ouvre le PDF
xdg-open guide_aim_training.pdf

echo "✓ Compilation terminée !"

