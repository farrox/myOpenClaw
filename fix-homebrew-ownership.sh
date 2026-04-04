#!/bin/bash
# Fix mixed Homebrew ownership under /usr/local (e.g. ed + tina, or root-owned prefix).
# Run in an interactive terminal: you will be prompted for your sudo password.

set -euo pipefail

OWNER_USER="${OWNER_USER:-ed}"
BREW_PREFIX="$(brew --prefix 2>/dev/null || echo /usr/local)"

if [[ "$BREW_PREFIX" != /usr/local ]]; then
  echo "Homebrew prefix is $BREW_PREFIX (not /usr/local)."
  echo "For Apple Silicon default, run instead:"
  echo "  sudo chown -R \"\$(whoami):admin\" /opt/homebrew"
  exit 1
fi

echo "Using owner ${OWNER_USER}:admin under ${BREW_PREFIX}"
echo "You may be prompted for your login password (sudo)."
echo ""

sudo chown -R "${OWNER_USER}:admin" \
  "${BREW_PREFIX}/Homebrew" \
  "${BREW_PREFIX}/Cellar" \
  "${BREW_PREFIX}/Caskroom" \
  "${BREW_PREFIX}/Frameworks" \
  "${BREW_PREFIX}/bin" \
  "${BREW_PREFIX}/etc" \
  "${BREW_PREFIX}/include" \
  "${BREW_PREFIX}/lib" \
  "${BREW_PREFIX}/opt" \
  "${BREW_PREFIX}/sbin" \
  "${BREW_PREFIX}/share" \
  "${BREW_PREFIX}/var"

# So other admin users (e.g. spouse account) can brew install without fighting perms
sudo chmod -R g+w "${BREW_PREFIX}/Cellar" "${BREW_PREFIX}/Caskroom" "${BREW_PREFIX}/var/homebrew" "${BREW_PREFIX}/opt" 2>/dev/null || true

echo ""
echo "Done. Verifying:"
ls -ld "${BREW_PREFIX}" "${BREW_PREFIX}/Cellar" "${BREW_PREFIX}/Homebrew" "${BREW_PREFIX}/var/homebrew" 2>/dev/null || true
echo ""
echo "Next: brew doctor && brew update && brew install gcalcli"
