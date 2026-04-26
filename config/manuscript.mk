# manuscript.mk — Shared Makefile fragment for building a manuscript.
# Include this from a per-manuscript Makefile after setting MANUSCRIPT_DIR.
#
# Expected variables (set by the per-manuscript Makefile):
#   MANUSCRIPT_DIR  — path to the manuscript directory (usually .)
#   ROOT_DIR        — path to the publishing project root
#
# Targets:
#   pdf     — build the final PDF (default)
#   tex     — convert all .md files to .tex fragments
#   clean   — remove build artifacts
#   info    — show manuscript metadata

SHELL := /bin/bash
.DEFAULT_GOAL := pdf

# Resolve paths
MANUSCRIPT_DIR ?= .
ROOT_DIR       ?= ..
BUILD_DIR      := $(MANUSCRIPT_DIR)/build
BIN_DIR        := $(ROOT_DIR)/bin
CONFIG_DIR     := $(ROOT_DIR)/config
LIB_DIR        := $(ROOT_DIR)/lib
PARSE_MANIFEST := $(BIN_DIR)/parse-manifest.sh
TEMPLATE       := $(CONFIG_DIR)/template.tex
DEFAULTS       := $(CONFIG_DIR)/defaults.yaml

# Read manuscript metadata via the manifest parser
TITLE     := $(shell $(PARSE_MANIFEST) $(MANUSCRIPT_DIR) title)
AUTHOR    := $(shell $(PARSE_MANIFEST) $(MANUSCRIPT_DIR) author)
SUBTITLE  := $(shell $(PARSE_MANIFEST) $(MANUSCRIPT_DIR) subtitle)
DOC_CLASS := $(shell $(PARSE_MANIFEST) $(MANUSCRIPT_DIR) class)
LANG      := $(shell $(PARSE_MANIFEST) $(MANUSCRIPT_DIR) lang)
DATE      := $(shell $(PARSE_MANIFEST) $(MANUSCRIPT_DIR) date)
MD_FILES  := $(shell $(PARSE_MANIFEST) $(MANUSCRIPT_DIR) files)

# Derived values
PREAMBLE       := $(CONFIG_DIR)/$(DOC_CLASS).tex
TEX_FILES      := $(patsubst %.md,$(BUILD_DIR)/%.tex,$(MD_FILES))
MASTER_TEX     := $(BUILD_DIR)/master.tex
OUTPUT_PDF     := $(BUILD_DIR)/output.pdf
MANUSCRIPT_NAME := $(notdir $(abspath $(MANUSCRIPT_DIR)))

# LaTeX engine settings
LATEX_ENGINE  ?= xelatex
LATEXMK_FLAGS := -$(LATEX_ENGINE) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR)

# Pandoc flags for converting individual .md → .tex fragments
PANDOC_FLAGS := \
	--from=markdown+smart+yaml_metadata_block+implicit_figures+table_captions+footnotes+fenced_code_blocks+fenced_code_attributes+strikeout+superscript+subscript \
	--to=latex \
	--template=$(TEMPLATE) \
	--top-level-division=$(if $(filter book,$(DOC_CLASS)),chapter,section)

# --- Targets ---

.PHONY: pdf tex clean info master

pdf: $(OUTPUT_PDF)
	@echo "Built: $(OUTPUT_PDF)"

tex: $(TEX_FILES)
	@echo "Converted $(words $(TEX_FILES)) files to LaTeX"

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Convert each .md file to a .tex fragment (body only, no preamble)
$(BUILD_DIR)/%.tex: $(MANUSCRIPT_DIR)/%.md $(TEMPLATE) | $(BUILD_DIR)
	@echo "  PANDOC  $< → $@"
	@pandoc $< \
		--from=markdown+smart+implicit_figures+table_captions+footnotes+fenced_code_blocks+strikeout+superscript+subscript \
		--to=latex \
		--output=$@

# Generate the master .tex file that includes all fragments
GENERATE_MASTER := $(BIN_DIR)/generate-master.sh

$(MASTER_TEX): $(TEX_FILES) $(PREAMBLE) $(GENERATE_MASTER) | $(BUILD_DIR)
	@echo "  MASTER  $(MASTER_TEX)"
	@$(GENERATE_MASTER) "$(MASTER_TEX)" "$(DOC_CLASS)" "$(TITLE)" "$(AUTHOR)" \
		"$(DATE)" "$(SUBTITLE)" "$(abspath $(PREAMBLE))" \
		"$(abspath $(MANUSCRIPT_DIR))" "$(abspath $(LIB_DIR))" \
		$(TEX_FILES)

# Compile the master .tex to PDF
$(OUTPUT_PDF): $(MASTER_TEX)
	@echo "  LATEXMK $(MASTER_TEX) → $(OUTPUT_PDF)"
	@cd $(BUILD_DIR) && \
		TEXINPUTS="$(abspath $(MANUSCRIPT_DIR)):$(abspath $(LIB_DIR)/styles):$(abspath $(CONFIG_DIR)):$$TEXINPUTS" \
		TTFONTS="$(abspath $(LIB_DIR)/fonts):$$TTFONTS" \
		OPENTYPEFONTS="$(abspath $(LIB_DIR)/fonts):$$OPENTYPEFONTS" \
		latexmk -$(LATEX_ENGINE) -interaction=nonstopmode -halt-on-error \
			$(notdir $(MASTER_TEX))
	@if [ -f "$(BUILD_DIR)/master.pdf" ]; then \
		cp "$(BUILD_DIR)/master.pdf" "$(OUTPUT_PDF)" 2>/dev/null || true; \
	fi

clean:
	@echo "  CLEAN   $(BUILD_DIR)"
	@rm -rf $(BUILD_DIR)

info:
	@echo "Manuscript: $(MANUSCRIPT_NAME)"
	@echo "Title:      $(TITLE)"
	@echo "Author:     $(AUTHOR)"
	@echo "Class:      $(DOC_CLASS)"
	@echo "Language:   $(LANG)"
	@echo "Files:      $(MD_FILES)"
