#!/bin/bash

# =============================================
# save-prototype.sh
# Commits, pushes, and prints the live URL
# Usage: ./save-prototype.sh
# =============================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
REPO_URL=$(git config --get remote.origin.url)

# Extract GitHub username and repo name from remote URL
# Handles both HTTPS and SSH formats
if [[ "$REPO_URL" == *"github.com"* ]]; then
  REPO_PATH=$(echo "$REPO_URL" | sed 's/.*github\.com[:/]//' | sed 's/\.git$//')
  GH_USER=$(echo "$REPO_PATH" | cut -d'/' -f1)
  GH_REPO=$(echo "$REPO_PATH" | cut -d'/' -f2)
else
  echo -e "${YELLOW}⚠ Could not detect GitHub remote. Make sure your remote is set.${NC}"
  exit 1
fi

echo ""
echo -e "${BLUE}💾 Saving prototype on branch: ${BRANCH}${NC}"
echo ""

# Stage all changes
git add .

# Check if there's anything to commit
if git diff --cached --quiet; then
  echo -e "${YELLOW}Nothing new to commit. Already up to date.${NC}"
else
  # Prompt for commit message
  echo -n "  Enter a commit message (optional, press Enter to skip): "
  read COMMIT_MSG

  if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="prototype update $(date '+%Y-%m-%d %H:%M')"
  fi

  git commit -m "$COMMIT_MSG"
  echo -e "${GREEN}✔ Committed: ${COMMIT_MSG}${NC}"
fi

# Push to origin
echo ""
echo -e "${BLUE}Pushing to origin/${BRANCH}...${NC}"
git push origin "$BRANCH"
echo -e "${GREEN}✔ Pushed successfully${NC}"

# Construct GitHub Pages URL
# GitHub Pages serves from: https://username.github.io/repo/
# For branch-based previews you'd typically use a tool like gh-pages
# This URL assumes GitHub Pages is set to deploy from main or a gh-pages branch
# and the prototype lives at a subfolder matching the branch name

CLEAN_BRANCH=$(echo "$BRANCH" | sed 's/prototype\///')
LIVE_URL="https://${GH_USER}.github.io/soundcheck/"

echo ""
echo -e "${GREEN}✅ Done!${NC}"
echo ""
echo -e "${CYAN}🌐 Your prototype is live at:${NC}"
echo -e "${CYAN}   ${LIVE_URL}${NC}"
echo ""

# Copy URL to clipboard (macOS)
if command -v pbcopy &> /dev/null; then
  echo "$LIVE_URL" | pbcopy
  echo -e "   📋 URL copied to clipboard"
fi

echo ""
echo -e "   Branch: ${BRANCH}"
echo ""
