# OpenClaw Security Guide - PDF Generation

This directory contains two methods for generating a professional PDF from the OpenClaw Security Guide.

## Method 1: XeLaTeX with Adobe Clean Font (Recommended)

**Script:** `generate_pdf_xelatex.sh`

### Features
- ✨ **Adobe Clean** sans-serif font (professional Adobe typography)
- 🎨 **Colorful hyperlinks** 
  - Blue internal links
  - Purple URLs
  - Green citations
- 🔗 **Modern URL formatting** with proper line breaking
- 📑 **Numbered sections** with table of contents
- 💎 **Syntax-highlighted code blocks**
- 📄 **Professional layout** with headers and footers

### Requirements
- XeLaTeX (part of MacTeX): `brew install --cask mactex-no-gui`
- Pandoc: `brew install pandoc`
- MiKTeX configured for automatic package installation
- **Adobe Clean font files** in `latex/fonts/` directory (not included in repo due to licensing)

### Usage
```bash
cd /Users/ed/Developer/myOpenClaw
./latex/generate_pdf_xelatex.sh
```

### Output
- **File:** `latex/OpenClaw_Security_Guide.pdf`
- **Font:** Adobe Clean (included in `fonts/` directory)
- **Compiler:** XeLaTeX

---

## Method 2: Chrome Headless (Legacy)

**Script:** `generate_pdf.sh`

### Features
- ✅ No LaTeX dependencies required
- ✅ Consistent HTML-based rendering
- ✅ Fast compilation

### Requirements
- Pandoc: `brew install pandoc`
- Google Chrome

### Usage
```bash
cd /Users/ed/Developer/myOpenClaw
./latex/generate_pdf.sh
```

### Output
- **File:** `latex/OpenClaw_Security_Guide.pdf`
- **Font:** System default
- **Renderer:** Chrome headless

---

## Comparison

| Feature | XeLaTeX | Chrome |
|---------|---------|--------|
| Professional Typography | ✅ Adobe Clean | ⚠️ System fonts |
| Colorful Links | ✅ Blue/Purple/Green | ⚠️ Limited |
| Code Highlighting | ✅ Full syntax | ⚠️ Basic |
| Custom Fonts | ✅ TTF/OTF support | ❌ Limited |
| Speed | ⚠️ Slower (10-15s) | ✅ Fast (3-5s) |
| Dependencies | ⚠️ Requires MacTeX | ✅ Only Chrome |
| Customization | ✅ Extensive | ⚠️ Limited |

## Recommendation

**Use XeLaTeX** (`generate_pdf_xelatex.sh`) for:
- Final deliverables
- Professional documents
- Custom typography
- Print-ready PDFs

**Use Chrome** (`generate_pdf.sh`) for:
- Quick previews
- Testing content changes
- Minimal setup environments

---

## Customizing the LaTeX Template

The XeLaTeX method uses `template.tex` for formatting. You can customize:

### Fonts
```latex
\setmainfont{AdobeClean}[
    Path = fonts/,
    Extension = .ttf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
    ItalicFont = *-It,
    BoldItalicFont = *-BoldIt
]
```

### Link Colors
```latex
\definecolor{linkblue}{RGB}{0,102,204}
\definecolor{urlpurple}{RGB}{128,0,128}
\definecolor{citegreen}{RGB}{0,128,0}
```

### Page Layout
```latex
\usepackage[letterpaper,margin=1in,top=1.2in,bottom=1.2in]{geometry}
```

### Headers/Footers
```latex
\fancyhead[L]{\small\textit{OpenClaw Security Guide}}
\fancyhead[R]{\small\thepage}
\fancyfoot[C]{\small\textit{Last updated: February 1, 2026}}
```

---

## Troubleshooting

### Missing LaTeX Packages

If you see errors about missing packages:

```bash
# Enable auto-install
initexmf --set-config-value '[MPM]AutoInstall=1'
initexmf --update-fndb

# Or install packages manually
mpm --install=<package-name>
```

### Font Not Found

**Note:** Adobe font files are not included in this repository due to licensing restrictions.

To use Adobe Clean font, you need to:
1. Obtain Adobe Clean font files (Regular, Bold, Italic, BoldItalic)
2. Place them in `latex/fonts/` directory:
   ```bash
   latex/fonts/
   ├── AdobeClean-Regular.ttf
   ├── AdobeClean-Bold.ttf
   ├── AdobeClean-It.ttf
   └── AdobeClean-BoldIt.ttf
   ```
3. Verify they exist:
   ```bash
   ls latex/fonts/AdobeClean*.ttf
   ```

**Alternative:** Use a different font by modifying `template.tex`:
```latex
% Replace Adobe Clean with a system font
\setmainfont{Helvetica Neue}  % or Arial, etc.
```

### Emoji/Symbol Warnings

The Adobe Clean font doesn't include emoji characters. These warnings are cosmetic:
```
[WARNING] Missing character: There is no ✅ (U+2705) in font...
```

To fix, either:
1. Remove emojis from the source markdown
2. Add a fallback font for symbols in `template.tex`

### Permission Errors

If MiKTeX has permission issues:
```bash
# Use fix script
./fix-dev-permissions.sh

# Or manually fix
sudo chown -R $(whoami) "/Library/Application Support/MiKTeX"
```

---

## Files in This Directory

- **`template.tex`** - XeLaTeX template with Adobe Clean font
- **`generate_pdf_xelatex.sh`** - XeLaTeX-based PDF generator (recommended)
- **`generate_pdf.sh`** - Chrome-based PDF generator (legacy)
- **`configure_miktex.sh`** - MiKTeX auto-install configuration
- **`MIKTEX_SETUP.md`** - Detailed MiKTeX setup guide
- **`fonts/`** - Adobe font files (Clean, Minion Pro, Myriad Pro, etc.)
- **`OpenClaw_Security_Guide.pdf`** - Generated PDF output
- **`OpenClaw_Security_Guide.html`** - Intermediate HTML (Chrome method)

---

## Tips

### Faster Compilation

For faster iteration during development:

1. Use Chrome method for content previews
2. Switch to XeLaTeX for final output

### Version Control

Add to `.gitignore`:
```
latex/*.aux
latex/*.log
latex/*.out
latex/*.toc
```

Keep in repo:
```
latex/OpenClaw_Security_Guide.pdf
latex/template.tex
latex/*.sh
```

### Multiple Source Files

To generate PDF from a different markdown file:

```bash
# Edit generate_pdf_xelatex.sh, change this line:
SOURCE_FILE="OpenClaw_Complete_Guide.md"
# To:
SOURCE_FILE="YourFile.md"
```

---

*Last updated: February 1, 2026*
