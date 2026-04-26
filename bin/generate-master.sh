#!/usr/bin/env bash
# generate-master.sh — Generate a master LaTeX file from manuscript fragments.
#
# Usage:
#   generate-master.sh <output-file> <doc-class> <title> <author> <date> \
#       <subtitle> <preamble-file> <manuscript-dir> <lib-dir> <tex-files...>
set -euo pipefail

OUTPUT="$1"; shift
DOC_CLASS="$1"; shift
TITLE="$1"; shift
AUTHOR="$1"; shift
DATE="$1"; shift
SUBTITLE="$1"; shift
PREAMBLE="$1"; shift
MANUSCRIPT_DIR="$1"; shift
LIB_DIR="$1"; shift
TEX_FILES=("$@")

BUILD_DIR="$(dirname "$OUTPUT")"

cat > "$OUTPUT" << HEADER
% Auto-generated master file — do not edit
\documentclass[12pt,a4paper]{${DOC_CLASS}}

% Preamble
\usepackage{fontspec}
\usepackage{xunicode}
\usepackage{geometry}
\geometry{margin=1in}
\usepackage{setspace}
\onehalfspacing
\usepackage{parskip}
\usepackage{graphicx}
\graphicspath{{${MANUSCRIPT_DIR}/images/}{${LIB_DIR}/images/}}
\usepackage{longtable}
\usepackage{booktabs}
\usepackage{array}
\usepackage{enumitem}
\usepackage{fancyvrb}
\usepackage[unicode=true,colorlinks=true,linkcolor=blue,citecolor=blue,urlcolor=blue]{hyperref}
\usepackage{fancyhdr}
\setlength{\headheight}{14.5pt}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE,RO]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}

% Pandoc compatibility
\providecommand{\tightlist}{\setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
\usepackage{soul}
\usepackage{framed}
\usepackage{xcolor}
\definecolor{shadecolor}{RGB}{248,248,248}
\newenvironment{Shaded}{\begin{snugshade}}{\end{snugshade}}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{commandchars=\\\\\{\}}
\newcounter{none}
\newcommand{\AlertTok}[1]{\textcolor[rgb]{0.94,0.16,0.16}{#1}}
\newcommand{\AnnotationTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{#1}}}}
\newcommand{\AttributeTok}[1]{\textcolor[rgb]{0.77,0.63,0.00}{#1}}
\newcommand{\BaseNTok}[1]{\textcolor[rgb]{0.00,0.00,0.81}{#1}}
\newcommand{\BuiltInTok}[1]{#1}
\newcommand{\CharTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{#1}}
\newcommand{\CommentTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textit{#1}}}
\newcommand{\CommentVarTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{#1}}}}
\newcommand{\ConstantTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{#1}}
\newcommand{\ControlFlowTok}[1]{\textcolor[rgb]{0.13,0.29,0.53}{\textbf{#1}}}
\newcommand{\DataTypeTok}[1]{\textcolor[rgb]{0.13,0.29,0.53}{#1}}
\newcommand{\DecValTok}[1]{\textcolor[rgb]{0.00,0.00,0.81}{#1}}
\newcommand{\DocumentationTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{#1}}}}
\newcommand{\ErrorTok}[1]{\textcolor[rgb]{0.64,0.00,0.00}{\textbf{#1}}}
\newcommand{\ExtensionTok}[1]{#1}
\newcommand{\FloatTok}[1]{\textcolor[rgb]{0.00,0.00,0.81}{#1}}
\newcommand{\FunctionTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{#1}}
\newcommand{\ImportTok}[1]{#1}
\newcommand{\InformationTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{#1}}}}
\newcommand{\KeywordTok}[1]{\textcolor[rgb]{0.13,0.29,0.53}{\textbf{#1}}}
\newcommand{\NormalTok}[1]{#1}
\newcommand{\OperatorTok}[1]{\textcolor[rgb]{0.81,0.36,0.00}{\textbf{#1}}}
\newcommand{\OtherTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{#1}}
\newcommand{\PreprocessorTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textit{#1}}}
\newcommand{\RegionMarkerTok}[1]{#1}
\newcommand{\SpecialCharTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{#1}}
\newcommand{\SpecialStringTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{#1}}
\newcommand{\StringTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{#1}}
\newcommand{\VariableTok}[1]{\textcolor[rgb]{0.00,0.00,0.00}{#1}}
\newcommand{\VerbatimStringTok}[1]{\textcolor[rgb]{0.31,0.60,0.02}{#1}}
\newcommand{\WarningTok}[1]{\textcolor[rgb]{0.56,0.35,0.01}{\textbf{\textit{#1}}}}

% Class-specific preamble
\input{${PREAMBLE}}
HEADER

# Include any shared style files
if [ -d "${LIB_DIR}/styles" ]; then
    for sty in "${LIB_DIR}"/styles/*.sty; do
        [ -f "$sty" ] || continue
        name="$(basename "$sty" .sty)"
        echo "\\usepackage{${name}}" >> "$OUTPUT"
    done
fi

# Metadata
{
    echo ""
    echo "% Metadata"
    if [ -n "$SUBTITLE" ]; then
        echo "\\title{${TITLE}\\\\\\vspace{0.5em}{\\large ${SUBTITLE}}}"
    else
        echo "\\title{${TITLE}}"
    fi
    echo "\\author{${AUTHOR}}"
    echo "\\date{${DATE}}"
    echo ""
    echo "\\begin{document}"
    echo "\\maketitle"
} >> "$OUTPUT"

# Table of contents for book class
if [ "$DOC_CLASS" = "book" ]; then
    echo "\\tableofcontents" >> "$OUTPUT"
    echo "\\clearpage" >> "$OUTPUT"
fi

echo "" >> "$OUTPUT"

# Include each .tex fragment
for tex in "${TEX_FILES[@]}"; do
    basename="$(basename "$tex")"
    echo "\\input{${basename}}" >> "$OUTPUT"
done

{
    echo ""
    echo "\\end{document}"
} >> "$OUTPUT"
