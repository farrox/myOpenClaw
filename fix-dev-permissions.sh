#!/bin/bash
# Fix development tool ownership and permissions for shared access

echo "🔧 Fixing /usr/local permissions for shared access between ed and tina users..."

# Set group ownership to admin and enable group write permissions
sudo chgrp -R admin /usr/local/bin /usr/local/lib /usr/local/opt /usr/local/share /usr/local/Homebrew

# Add group write permissions
sudo chmod -R g+w /usr/local/bin /usr/local/lib /usr/local/opt /usr/local/share /usr/local/Homebrew

# Specifically fix node_modules to be owned by current user
sudo chown -R $USER:admin /usr/local/lib/node_modules

echo "✅ Permissions fixed!"
echo ""
echo "Now both 'ed' and 'tina' users can:"
echo "  - Install npm packages globally"
echo "  - Install Homebrew packages"
echo "  - Share development tools without permission issues"
echo ""
echo "You can now run: npm install -g openclaw"
