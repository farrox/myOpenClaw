# MiKTeX Auto-Install Configuration Guide

## Problem

When compiling LaTeX documents, MiKTeX may hang because it's waiting for permission to install missing packages. This happens because by default MiKTeX asks for confirmation before downloading packages.

## Solution: Enable Automatic Package Installation

### Method 1: Using MiKTeX Console (Recommended)

1. **Open MiKTeX Console:**
   ```bash
   open "/Applications/MiKTeX Console.app"
   ```

2. **Navigate to Settings:**
   - Click on the "Settings" tab

3. **Configure Package Installation:**
   - Find "Package installation" section
   - Select: **"Always install missing packages on-the-fly"**
   - Alternative: **"Ask me first"** (safer but requires interaction)

4. **Save Settings:**
   - Click "OK" or "Apply"

### Method 2: Command Line Configuration

Run the configuration script:
```bash
cd /Users/ed/Developer/moltstuff/latex
./configure_miktex.sh
```

Or manually:
```bash
# Enable auto-install
initexmf --set-config-value '[MPM]AutoInstall=1'

# Enable auto-admin (allows installing without prompts)
initexmf --set-config-value '[MPM]AutoAdmin=1'

# Update databases
initexmf --update-fndb
mpm --update-db
```

## Verifying Configuration

Check current settings:
```bash
initexmf --report | grep -i auto
```

## Troubleshooting

### Issue: "Package database is locked"

**Cause:** Another MiKTeX process is running or crashed

**Fix:**
```bash
# Find and kill MiKTeX processes
ps aux | grep miktex
kill <pid>

# Or restart your terminal/computer
```

### Issue: Permission denied errors

**Cause:** MiKTeX trying to install to system directories

**Fix:**
Run with proper permissions or configure user-level installation:
```bash
# User-level update
initexmf --update-fndb

# If needed, use sudo for system-level
sudo initexmf --admin --update-fndb
```

### Issue: Network/mirror problems

**Cause:** Can't reach package repository

**Fix:**
```bash
# Update repository mirror
mpm --set-repository=https://mirror.ctan.org/systems/win32/miktex/tm/packages/
mpm --update-db
```

## Testing LaTeX Compilation

After configuration, test with a simple document:

```bash
cd /Users/ed/Developer/moltstuff/latex

# This should now auto-install missing packages
pdflatex openclaw_guide_simple.tex
```

**Expected behavior:**
- You'll see "downloading package..." messages
- Packages install automatically
- Compilation completes without hanging

## Manual Package Installation

If auto-install isn't working, install packages manually:

```bash
# Install specific packages
mpm --install pdfescape
mpm --install hyperref
mpm --install listings
mpm --install fancyhdr
mpm --install lastpage
mpm --install xcolor
mpm --install enumitem
mpm --install titlesec
mpm --install booktabs
mpm --install titling
```

## Common Required Packages

For the OpenClaw guide LaTeX documents:
- pdfescape
- hyperref
- listings
- fancyhdr
- lastpage
- xcolor
- enumitem
- titlesec
- booktabs
- tabularx
- array
- graphicx
- geometry
- titling
- fancyvrb

## Alternative: Use Existing PDF Generation

Since MiKTeX can be finicky, the project includes working PDF generation using Chrome headless:

```bash
cd /Users/ed/Developer/moltstuff/latex
./generate_pdf.sh
```

This method:
- ✅ Doesn't require LaTeX packages
- ✅ Works consistently
- ✅ Produces high-quality PDFs
- ✅ Already generated: `OpenClaw_Security_Guide_Complete.pdf`

## Best Practice

**For this project:** The Chrome-based PDF generation is recommended because:
1. No package management hassles
2. Consistent output
3. Faster compilation
4. Already working!

**For future LaTeX projects:** Configure auto-install once using MiKTeX Console, then LaTeX will work smoothly.

## Resources

- [MiKTeX Package Manager Documentation](https://miktex.org/howto/mpm)
- [MiKTeX Configuration Guide](https://miktex.org/kb/miktex-configuration-guide)
- [Fix: Package Database Locked](https://miktex.org/kb/fix-package-database-locked)

---

*Last updated: February 1, 2026*
