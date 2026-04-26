# Copilot Instructions

## Build Commands

```bash
# Build all manuscripts
make

# Build a single manuscript
make sample-manuscript/
# or from within the manuscript directory:
cd sample-manuscript && make

# Build only the .tex intermediates (skip PDF compilation)
cd sample-manuscript && make tex

# Show manuscript metadata
cd sample-manuscript && make info

# Clean all build artifacts
make clean
```

Requires: Pandoc 3.x+, XeLaTeX (via MacTeX/TeX Live), latexmk, GNU Make, Bash.

XeLaTeX lives at `/Library/TeX/texbin` on macOS — ensure `PATH` includes it when running builds.

## Architecture

This is a Markdown-to-PDF publishing pipeline. The build flows:

```
*.md → Pandoc → *.tex fragments → generate-master.sh → master.tex → latexmk/xelatex → output.pdf
```

**Two-tier Makefile system:** The top-level `Makefile` auto-discovers manuscripts (any directory containing `manuscript.yaml`) and delegates to per-manuscript `Makefile`s. Per-manuscript Makefiles are thin wrappers that set `MANUSCRIPT_DIR` and `ROOT_DIR`, then include `config/manuscript.mk` which contains all build logic.

**Manuscript manifest:** Each manuscript is defined by a `manuscript.yaml` that specifies title, author, document class (`book` or `article`), and the ordered list of source `.md` files. The manifest is parsed by `bin/parse-manifest.sh` (a pure bash/awk YAML parser — no external YAML tooling).

**Master .tex generation:** `bin/generate-master.sh` assembles a complete LaTeX document from the individual `.tex` fragments. It handles document class selection, preamble inclusion, Pandoc compatibility macros (tightlist, syntax highlighting tokens, soul for strikethrough, Shaded environment), and fragment ordering. This script uses an **unquoted heredoc** — `\\` is interpreted as `\` by the shell; single `\` before non-special characters passes through unchanged.

**Document classes:** `config/book.tex` and `config/article.tex` provide class-specific preamble additions. For `book` class, top-level Markdown headings (`#`) become `\chapter`; for `article`, they become `\section`.

## Key Conventions

- Manuscript directories live at the project root alongside `bin/`, `config/`, `lib/`, and `help/`. A directory is recognised as a manuscript if it contains `manuscript.yaml`.
- File ordering is always defined in `manuscript.yaml` under `files:` — not by filesystem sort order. Both `.md` and `.tex` source files can be listed; `.md` files are converted via Pandoc, `.tex` files are copied directly to the build directory.
- Build output goes to `<manuscript>/build/`. The final PDF is `build/output.pdf` (copied from `build/master.pdf`).
- Shared assets in `lib/` (styles, fonts, images, bibliography) are automatically available to all manuscripts via `TEXINPUTS`, `graphicspath`, and font paths set in the Makefile.
- `.sty` files placed in `lib/styles/` are auto-included by `generate-master.sh`.
- Shell scripts in `bin/` use `set -euo pipefail` and must remain dependency-free (no Python, no external YAML parsers).
- `config/template.tex` is a Pandoc template — it uses Pandoc's `$if$`/`$for$` template syntax, not LaTeX conditionals.
