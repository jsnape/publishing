# Introduction

Welcome to the sample manuscript. This document demonstrates the publishing
pipeline that converts Markdown files into a professionally typeset PDF.

## Purpose

This pipeline allows authors to:

- Write content in Markdown, a simple and readable format
- Organise manuscripts into multiple files for easier management
- Produce high-quality PDF output via LaTeX typesetting
- Share common assets (styles, fonts, images) across manuscripts

## How It Works

Each manuscript lives in its own directory with a `manuscript.yaml` file that
defines the document metadata and the order of source files. The build system
converts each Markdown file to LaTeX, assembles them into a master document,
and compiles the final PDF.
