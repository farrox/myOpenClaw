#!/bin/bash
# MiKTeX Auto-Install Configuration Script

echo "🔧 Configuring MiKTeX for Automatic Package Installation"
echo ""

# Enable automatic package installation
echo "Step 1: Enabling automatic package installation..."
initexmf --set-config-value '[MPM]AutoInstall=1'
if [ $? -eq 0 ]; then
    echo "✅ AutoInstall enabled"
else
    echo "⚠️  Could not enable AutoInstall automatically"
fi

# Enable auto-admin mode
echo ""
echo "Step 2: Enabling auto-admin mode..."
initexmf --set-config-value '[MPM]AutoAdmin=1'
if [ $? -eq 0 ]; then
    echo "✅ AutoAdmin enabled"
else
    echo "⚠️  Could not enable AutoAdmin automatically"
fi

# Update filename database
echo ""
echo "Step 3: Updating filename database..."
initexmf --update-fndb
if [ $? -eq 0 ]; then
    echo "✅ Filename database updated"
else
    echo "⚠️  Could not update filename database"
fi

# Update package database
echo ""
echo "Step 4: Updating package database..."
mpm --update-db 2>&1 | head -5
if [ $? -eq 0 ]; then
    echo "✅ Package database updated"
else
    echo "⚠️  Could not update package database"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Configuration complete!"
echo ""
echo "📝 Manual Configuration (if needed):"
echo ""
echo "1. Open MiKTeX Console:"
echo "   /Applications/MiKTeX\\ Console.app/Contents/MacOS/miktex-console"
echo ""
echo "2. Go to Settings tab"
echo ""
echo "3. Under 'Package installation:', select one of:"
echo "   • 'Always install missing packages on-the-fly' (recommended)"
echo "   • 'Ask me first' (safer but requires interaction)"
echo ""
echo "4. Click 'OK' to save"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔍 Current Configuration:"
initexmf --report | grep -i "auto\|install" | head -5

echo ""
echo "📦 To manually install packages:"
echo "   mpm --install <package-name>"
echo ""
echo "Example:"
echo "   mpm --install pdfescape"
echo "   mpm --install hyperref"
echo ""
echo "💡 Tip: Run LaTeX compilation again. If it hangs, it's waiting"
echo "   for package installation approval. Check MiKTeX Console."
