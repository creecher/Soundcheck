#!/bin/bash

# =============================================
# new-prototype.sh — Soundcheck
# Creates a new prototype branch and seeds its data
# Usage: ./new-prototype.sh feature-name
# =============================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage: ./new-prototype.sh <feature-name>${NC}"
  echo -e "Example: ./new-prototype.sh nav-redesign"
  exit 1
fi

FEATURE_NAME="$1"
BRANCH_NAME="prototype/$FEATURE_NAME"
PROTOTYPE_ID="$FEATURE_NAME"

echo ""
echo -e "${BLUE}🎙 Soundcheck — Creating new prototype: ${BRANCH_NAME}${NC}"
echo ""

# Make sure we're on main and up to date
git checkout main
git pull origin main

# Create and switch to new branch
git checkout -b "$BRANCH_NAME"
echo -e "${GREEN}✔ Branch created: ${BRANCH_NAME}${NC}"

# Inject the prototype-id into index.html so db.js knows its scope
# Replaces: <meta name="prototype-id" content="...">
sed -i.bak "s|content=\"dev\"|content=\"${PROTOTYPE_ID}\"|g" index.html && rm -f index.html.bak
echo -e "${GREEN}✔ Prototype ID set: ${PROTOTYPE_ID}${NC}"

# Seed this prototype's data from the base seed rows
echo ""
echo -e "${BLUE}Seeding prototype data...${NC}"
./seed-prototype.sh "$PROTOTYPE_ID"

# Open in VS Code if available
if command -v code &> /dev/null; then
  echo ""
  echo -e "${BLUE}Opening in VS Code...${NC}"
  code .
fi

echo ""
echo -e "${GREEN}✅ Prototype ready!${NC}"
echo ""
echo "  Branch:       $BRANCH_NAME"
echo "  Prototype ID: $PROTOTYPE_ID"
echo ""
echo "  Next steps:"
echo "  1. Fill in BRIEF.md with your problem context"
echo "  2. Open Claude Code: claude"
echo "  3. Say: 'Read CLAUDE.md and BRIEF.md, then let's plan this prototype'"
echo "  4. Build it. When done, run: ./save-prototype.sh"
echo ""
