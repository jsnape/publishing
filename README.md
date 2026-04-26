# Publishing Pipeline

A Markdown-to-PDF publishing pipeline using Pandoc and LaTeX.

## Overview

Write manuscripts in Markdown, build professionally typeset PDFs with a single
command. Each manuscript lives in its own directory with a manifest file that
controls metadata, document class, and file ordering.

## Prerequisites

- [Pandoc](https://pandoc.org/) 3.x+
- A TeX distribution with XeLaTeX (e.g. [MacTeX](https://tug.org/mactex/),
  [TeX Live](https://tug.org/texlive/))
- [latexmk](https://ctan.org/pkg/latexmk)
- GNU Make
- Bash

## Quick Start

```bash
# Build all manuscripts
make

# Build a specific manuscript
make sample-manuscript/

# Build from within a manuscript directory
cd sample-manuscript
make

# Clean build artifacts
make clean
```

## Directory Structure

```
publishing/
├── Makefile              # Top-level build orchestration
├── bin/                  # Shared scripts
├── config/               # LaTeX templates, preambles, shared Makefile
├── lib/                  # Shared assets (styles, fonts, images, bibliography)
│   ├── styles/           # Shared .sty files
│   ├── fonts/            # Shared fonts
│   ├── images/           # Shared images (logos, etc.)
│   └── bibliography/     # Shared .bib files
├── help/                 # Reference documentation
└── <manuscript>/         # Each manuscript in its own directory
    ├── manuscript.yaml   # Manifest: metadata + file order
    ├── Makefile          # Per-manuscript Makefile
    ├── *.md              # Markdown source files
    └── images/           # Manuscript-specific images
```

## Creating a New Manuscript

1. Create a new directory at the project root:

   ```bash
   mkdir my-manuscript
   ```

2. Add a `manuscript.yaml`:

   ```yaml
   title: "My Document"
   author: "Your Name"
   date: "2026"
   class: book          # or: article
   lang: en-GB
   files:
     - 01-introduction.md
     - 02-content.md
     - 03-conclusion.md
   ```

3. Add a `Makefile`:

   ```makefile
   MANUSCRIPT_DIR := .
   ROOT_DIR       := ..
   include $(ROOT_DIR)/config/manuscript.mk
   ```

4. Write your Markdown files and build:

   ```bash
   cd my-manuscript
   make
   ```

   The PDF will be generated in `my-manuscript/build/output.pdf`.

## Make Targets

### Top-level

| Target             | Description                         |
|--------------------|-------------------------------------|
| `make`             | Build all manuscripts               |
| `make <dir>/`      | Build a specific manuscript         |
| `make clean`       | Clean all build artifacts           |
| `make list`        | List discovered manuscripts         |
| `make help`        | Show available targets              |

### Per-manuscript

| Target       | Description                              |
|--------------|------------------------------------------|
| `make pdf`   | Build the PDF (default)                  |
| `make tex`   | Convert .md to .tex only                 |
| `make clean` | Remove build directory                   |
| `make info`  | Display manuscript metadata              |

## Shared Assets

The `lib/` directory contains assets shared across all manuscripts:

- **`lib/styles/`** — LaTeX style files (.sty) automatically available
- **`lib/fonts/`** — Fonts available to all manuscripts via XeLaTeX
- **`lib/images/`** — Common images (logos, shared figures)
- **`lib/bibliography/`** — Shared bibliography (.bib) files

## Help

See the `help/` directory for reference documentation:

- [`help/manuscript-yaml.md`](help/manuscript-yaml.md) — Manifest file format
- [`help/markdown-guide.md`](help/markdown-guide.md) — Supported Markdown syntax
