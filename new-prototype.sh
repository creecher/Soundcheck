#!/bin/bash

# =============================================
# new-prototype.sh — Soundcheck
# Creates a new prototype branch from main
# Usage: ./new-prototype.sh feature-name
# =============================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for argument
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage: ./new-prototype.sh <feature-name>${NC}"
  echo -e "Example: ./new-prototype.sh nav-redesign"
  exit 1
fi

BRANCH_NAME="prototype/$1"
echo ""
echo -e "${BLUE}🎙 Soundcheck — Creating new prototype: ${BRANCH_NAME}${NC}"
echo ""

# Make sure we're on main and up to date
git checkout main
git pull origin main

# Create and switch to new branch
git checkout -b "$BRANCH_NAME"

echo -e "${GREEN}✔ Branch created: ${BRANCH_NAME}${NC}"

# Open in VS Code if available
if command -v code &> /dev/null; then
  echo ""
  echo -e "${BLUE}Opening in VS Code...${NC}"
  code .
fi

echo ""
echo -e "${GREEN}✅ Prototype ready!${NC}"
echo ""
echo "  Next steps:"
echo "  1. Fill in BRIEF.md with your problem context"
echo "  2. Open Claude Code: claude"
echo "  3. Say: 'Read BRIEF.md and let's plan the prototype'"
echo "  4. Build it. When done, run: ./save-prototype.sh"
echo ""
