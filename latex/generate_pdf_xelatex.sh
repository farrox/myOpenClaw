#!/bin/bash
# OpenClaw Security Guide - Professional PDF Generator with XeLaTeX
# Uses Adobe Clean font, colorful links, and modern formatting

set -e

cd "$(dirname "$0")/.."

echo "🦞 OpenClaw Security Guide - Professional PDF Generator (XeLaTeX)"
echo ""
echo "Author: Ed Shah"
echo "Based on original work by Bill D'Alessandro (@BillDA)"
echo ""

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "❌ Error: pandoc is not installed"
    echo "Install with: brew install pandoc"
    exit 1
fi

# Check if xelatex is installed
if ! command -v xelatex &> /dev/null; then
    echo "❌ Error: xelatex is not installed"
    echo "Install with: brew install --cask mactex-no-gui"
    echo "Or full MacTeX: brew install --cask mactex"
    exit 1
fi

echo "✅ Dependencies found"
echo ""

# Determine source file
SOURCE_FILE="OpenClaw_Complete_Guide.md"
if [ ! -f "$SOURCE_FILE" ]; then
    echo "⚠️  Warning: $SOURCE_FILE not found, falling back to README.md"
    SOURCE_FILE="README.md"
fi

if [ ! -f "$SOURCE_FILE" ]; then
    echo "❌ Error: No markdown source file found"
    exit 1
fi

echo "📄 Source: $SOURCE_FILE"
echo ""

# Clean up any previous builds
rm -f latex/OpenClaw_Security_Guide.aux
rm -f latex/OpenClaw_Security_Guide.log
rm -f latex/OpenClaw_Security_Guide.out
rm -f latex/OpenClaw_Security_Guide.toc

echo "Step 1: Converting Markdown to PDF with XeLaTeX..."
echo ""

cd latex

pandoc "../$SOURCE_FILE" \
    -o OpenClaw_Security_Guide.pdf \
    --pdf-engine=xelatex \
    --template=template.tex \
    --toc \
    --toc-depth=3 \
    --number-sections \
    --metadata title="OpenClaw Security Guide" \
    --metadata author="Ed Shah (adapted from Bill D'Alessandro)" \
    --metadata date="February 2026" \
    --syntax-highlighting=tango \
    -V geometry:margin=1in \
    -V fontsize=11pt \
    -V papersize=letter \
    -V documentclass=article

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ PDF generated successfully!"
    echo ""
    ls -lh OpenClaw_Security_Guide.pdf
    echo ""
    echo "📄 Location: $(pwd)/OpenClaw_Security_Guide.pdf"
    echo ""
    
    # Clean up auxiliary files
    rm -f OpenClaw_Security_Guide.aux
    rm -f OpenClaw_Security_Guide.log
    rm -f OpenClaw_Security_Guide.out
    rm -f OpenClaw_Security_Guide.toc
    
    echo "Opening PDF..."
    open "OpenClaw_Security_Guide.pdf"
else
    echo "❌ PDF generation failed"
    echo ""
    echo "Check the log file for details:"
    echo "  latex/OpenClaw_Security_Guide.log"
    exit 1
fi

echo ""
echo "✨ Done! Your professional PDF with Adobe Clean font is ready."
echo ""
echo "Features:"
echo "  ✓ Adobe Clean sans-serif font"
echo "  ✓ Colorful hyperlinks (blue links, purple URLs, green citations)"
echo "  ✓ Modern URL formatting"
echo "  ✓ Table of contents with page numbers"
echo "  ✓ Professional layout and spacing"
