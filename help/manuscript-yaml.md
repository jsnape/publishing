# manuscript.yaml Reference

Each manuscript directory must contain a `manuscript.yaml` file that defines
the document metadata and source file ordering.

## Format

```yaml
title: "My Manuscript Title"
subtitle: "Optional Subtitle"        # optional
author: "Author Name"
date: "2026"
class: book                          # book | article
lang: en-GB                          # BCP 47 language tag (default: en-GB)
files:
  - 01-introduction.md
  - 02-chapter-one.md
  - 03-chapter-two.md
  - 04-conclusion.md
```

## Fields

| Field      | Required | Default | Description                              |
|------------|----------|---------|------------------------------------------|
| `title`    | Yes      | —       | Document title                           |
| `subtitle` | No       | —       | Subtitle (displayed below title)         |
| `author`   | Yes      | —       | Author name(s)                           |
| `date`     | No       | —       | Publication date                         |
| `class`    | No       | `book`  | LaTeX document class: `book` or `article`|
| `lang`     | No       | `en-GB` | Language for hyphenation and typography  |
| `files`    | Yes      | —       | Ordered list of Markdown source files    |

## Document Classes

### `book`

- Supports `\chapter`, `\section`, `\subsection` etc.
- Automatically generates a table of contents
- Suitable for longer works with multiple chapters

### `article`

- Top-level headings become `\section` (no chapters)
- Lighter structure, suitable for papers and reports
- No automatic table of contents (can be enabled in config)

## File Ordering

Files are included in the PDF in exactly the order listed under `files:`.
A common convention is to prefix filenames with numbers:

```
01-introduction.md
02-literature-review.md
03-methodology.md
04-results.md
05-conclusion.md
```

This keeps files naturally sorted in file browsers while the manifest
remains the authoritative source of ordering.
