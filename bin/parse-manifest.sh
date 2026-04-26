#!/usr/bin/env bash
# parse-manifest.sh — Read manuscript.yaml and output information.
#
# Usage:
#   parse-manifest.sh <manuscript-dir> files    # ordered list of source files
#   parse-manifest.sh <manuscript-dir> title    # manuscript title
#   parse-manifest.sh <manuscript-dir> author   # manuscript author
#   parse-manifest.sh <manuscript-dir> class    # document class (book|article)
#   parse-manifest.sh <manuscript-dir> field <name>  # arbitrary top-level field
set -euo pipefail

MANUSCRIPT_DIR="${1:-.}"
ACTION="${2:-files}"
MANIFEST="${MANUSCRIPT_DIR}/manuscript.yaml"

if [[ ! -f "$MANIFEST" ]]; then
    echo "Error: ${MANIFEST} not found" >&2
    exit 1
fi

# Simple YAML parser — no external dependencies required.
# Handles the flat key: value and list formats used in manuscript.yaml.

get_field() {
    local field="$1"
    sed -n "s/^${field}:[[:space:]]*[\"']*\([^\"']*\)[\"']*/\1/p" "$MANIFEST" | head -1
}

get_files() {
    # Extract lines under "files:" until the next top-level key or EOF
    awk '
        /^files:/ { in_files=1; next }
        in_files && /^[^ #-]/ { exit }
        in_files && /^[[:space:]]*-[[:space:]]*/ {
            sub(/^[[:space:]]*-[[:space:]]*/, "")
            gsub(/[\"'"'"']/, "")
            gsub(/[[:space:]]*$/, "")
            print
        }
    ' "$MANIFEST"
}

case "$ACTION" in
    files)
        get_files
        ;;
    title)
        get_field "title"
        ;;
    author)
        get_field "author"
        ;;
    subtitle)
        get_field "subtitle"
        ;;
    class)
        CLASS=$(get_field "class")
        echo "${CLASS:-book}"
        ;;
    lang)
        LANG_VAL=$(get_field "lang")
        echo "${LANG_VAL:-en-GB}"
        ;;
    date)
        get_field "date"
        ;;
    field)
        FIELD_NAME="${3:-}"
        if [[ -z "$FIELD_NAME" ]]; then
            echo "Error: field name required" >&2
            exit 1
        fi
        get_field "$FIELD_NAME"
        ;;
    *)
        echo "Usage: $0 <manuscript-dir> {files|title|author|subtitle|class|lang|date|field <name>}" >&2
        exit 1
        ;;
esac
