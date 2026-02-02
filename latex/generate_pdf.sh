#!/bin/bash
# OpenClaw Security Guide - PDF Generator
# Converts README.md to professional PDF

cd "$(dirname "$0")/.."

echo "🦞 OpenClaw Security Guide - PDF Generator"
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

# Check if Chrome is available
if [ ! -f "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
    echo "❌ Error: Google Chrome not found"
    echo "Please install Google Chrome"
    exit 1
fi

echo "Step 1: Converting README.md to HTML..."
pandoc README.md -o latex/OpenClaw_Security_Guide.html \
    --standalone \
    --toc \
    --toc-depth=2 \
    --metadata title="OpenClaw Security Guide"

if [ $? -eq 0 ]; then
    echo "✅ HTML generated"
else
    echo "❌ HTML generation failed"
    exit 1
fi

echo ""
echo "Step 2: Converting HTML to PDF with Chrome..."
cd latex

"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --headless \
    --disable-gpu \
    --print-to-pdf="OpenClaw_Security_Guide.pdf" \
    --print-to-pdf-no-header \
    --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    "file://$(pwd)/OpenClaw_Security_Guide.html" 2>&1 | grep -i "bytes written"

if [ -f "OpenClaw_Security_Guide.pdf" ]; then
    echo "✅ PDF generated successfully!"
    echo ""
    ls -lh OpenClaw_Security_Guide.pdf
    echo ""
    echo "📄 Location: $(pwd)/OpenClaw_Security_Guide.pdf"
    echo ""
    echo "Opening PDF..."
    open "OpenClaw_Security_Guide.pdf"
else
    echo "❌ PDF generation failed"
    exit 1
fi

echo ""
echo "✨ Done! PDF is ready to share."
