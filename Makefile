# Publishing Pipeline — Top-level Makefile
# Discovers all manuscript directories (containing manuscript.yaml) and
# delegates build/clean operations to per-manuscript Makefiles.

SHELL := /bin/bash

# Find all manuscript directories (any dir with a manuscript.yaml)
MANUSCRIPTS := $(sort $(dir $(wildcard */manuscript.yaml)))

.PHONY: all clean list help $(MANUSCRIPTS)

all: $(MANUSCRIPTS)
	@echo "All manuscripts built."

$(MANUSCRIPTS):
	@echo "=== Building $@ ==="
	@$(MAKE) -C $@ pdf

clean:
	@for dir in $(MANUSCRIPTS); do \
		echo "=== Cleaning $$dir ==="; \
		$(MAKE) -C $$dir clean; \
	done
	@echo "All manuscripts cleaned."

list:
	@echo "Manuscripts found:"
	@for dir in $(MANUSCRIPTS); do \
		echo "  $$dir"; \
	done

help:
	@echo "Publishing Pipeline"
	@echo ""
	@echo "Usage:"
	@echo "  make              Build all manuscripts"
	@echo "  make list         List discovered manuscripts"
	@echo "  make clean        Clean all build artifacts"
	@echo "  make <dir>/       Build a specific manuscript (e.g., make sample-manuscript/)"
	@echo ""
	@echo "Per-manuscript (run from manuscript directory):"
	@echo "  make pdf          Build the PDF (default)"
	@echo "  make tex          Convert .md files to .tex only"
	@echo "  make clean        Remove build artifacts"
	@echo "  make info         Show manuscript metadata"
