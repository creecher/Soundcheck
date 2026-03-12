#!/bin/bash

# =============================================
# seed-prototype.sh — Soundcheck
# Copies base seed data into a prototype's own scope.
# Safe to re-run — deletes and re-seeds cleanly.
#
# Called automatically by new-prototype.sh.
# Run manually to reset a prototype's data:
#   ./seed-prototype.sh              (uses current branch)
#   ./seed-prototype.sh my-feature   (explicit name)
# =============================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Determine prototype ID
if [ -n "$1" ]; then
  PROTOTYPE_ID="$1"
else
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [[ "$BRANCH" == prototype/* ]]; then
    PROTOTYPE_ID="${BRANCH#prototype/}"
  else
    echo -e "${YELLOW}⚠ Not on a prototype branch. Pass the name explicitly:${NC}"
    echo -e "  ./seed-prototype.sh my-feature-name"
    exit 1
  fi
fi

# Load Supabase credentials from db.js
SUPABASE_URL=$(grep "const SUPABASE_URL" js/db.js | head -1 | sed "s/.*= '//;s/';.*//")
SUPABASE_KEY=$(grep "const SUPABASE_ANON_KEY" js/db.js | head -1 | sed "s/.*= '//;s/';.*//")

if [[ "$SUPABASE_URL" == "YOUR_SUPABASE_URL" || -z "$SUPABASE_URL" ]]; then
  echo -e "${RED}❌ Supabase credentials not set in js/db.js${NC}"
  echo "   Set SUPABASE_URL and SUPABASE_ANON_KEY in js/db.js first."
  exit 1
fi

echo ""
echo -e "${BLUE}🌱 Seeding prototype: ${PROTOTYPE_ID}${NC}"
echo ""

TABLES=("clients" "diagnoses" "medications" "allergies" "vitals" "warm_line_calls" "referrals" "care_journey_events")

for TABLE in "${TABLES[@]}"; do
  echo -n "  ${TABLE}... "

  # Step 1: Delete any existing rows for this prototype (makes re-runs safe)
  curl -s -o /dev/null \
    -X DELETE "${SUPABASE_URL}/rest/v1/${TABLE}?prototype_id=eq.${PROTOTYPE_ID}" \
    -H "apikey: ${SUPABASE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_KEY}"

  # Step 2: Fetch seed rows
  SEED_ROWS=$(curl -s \
    "${SUPABASE_URL}/rest/v1/${TABLE}?prototype_id=eq.seed" \
    -H "apikey: ${SUPABASE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_KEY}" \
    -H "Accept: application/json")

  if [ "$SEED_ROWS" == "[]" ] || [ -z "$SEED_ROWS" ]; then
    echo -e "${YELLOW}(no seed rows)${NC}"
    continue
  fi

  # Step 3: Remap — new prototype_id, new IDs with short suffix to avoid PK collisions
  REMAPPED=$(echo "$SEED_ROWS" | python3 -c "
import json, sys

rows = json.load(sys.stdin)
proto_id = '${PROTOTYPE_ID}'
# Use a short stable suffix from the prototype name (first 8 chars)
suffix = proto_id[:8].replace('-', '')

new_rows = []
for row in rows:
    new_row = dict(row)
    new_row['prototype_id'] = proto_id
    if 'id' in new_row and new_row['id']:
        new_row['id'] = new_row['id'] + '-' + suffix
    new_rows.append(new_row)

print(json.dumps(new_rows))
")

  # Step 4: Insert
  RESULT=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST "${SUPABASE_URL}/rest/v1/${TABLE}" \
    -H "apikey: ${SUPABASE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_KEY}" \
    -H "Content-Type: application/json" \
    -H "Prefer: return=minimal" \
    -d "$REMAPPED")

  if [[ "$RESULT" == "2"* ]]; then
    COUNT=$(echo "$SEED_ROWS" | python3 -c "import json,sys; print(len(json.load(sys.stdin)))")
    echo -e "${GREEN}✔ ${COUNT} rows${NC}"
  else
    echo -e "${RED}✗ HTTP ${RESULT}${NC}"
  fi
done

echo ""
echo -e "${GREEN}✅ Prototype '${PROTOTYPE_ID}' seeded${NC}"
echo ""
echo "  Writes will be tagged: prototype_id = '${PROTOTYPE_ID}'"
echo "  Reads will return seed rows + this prototype's rows."
echo ""
echo "  To reset: ./seed-prototype.sh ${PROTOTYPE_ID}"
echo ""
