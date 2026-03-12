#!/bin/bash

# =============================================
# seed-prototype.sh — Soundcheck
# Copies base seed data into a prototype's own scope
# so it starts with a full realistic dataset.
#
# Called automatically by new-prototype.sh.
# Can also be run manually to reset a prototype's data:
#   ./seed-prototype.sh          (uses current branch)
#   ./seed-prototype.sh my-feature  (explicit prototype name)
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
    echo -e "${YELLOW}⚠ Not on a prototype branch. Pass the prototype name explicitly:${NC}"
    echo -e "  ./seed-prototype.sh my-feature-name"
    exit 1
  fi
fi

# Load Supabase credentials from db.js
SUPABASE_URL=$(grep 'SUPABASE_URL' js/db.js | head -1 | sed "s/.*= '//;s/';.*//")
SUPABASE_KEY=$(grep 'SUPABASE_ANON_KEY' js/db.js | head -1 | sed "s/.*= '//;s/';.*//")

if [[ "$SUPABASE_URL" == "YOUR_SUPABASE_URL" || -z "$SUPABASE_URL" ]]; then
  echo -e "${RED}❌ Supabase credentials not set in js/db.js${NC}"
  echo "   Set SUPABASE_URL and SUPABASE_ANON_KEY in js/db.js first."
  exit 1
fi

echo ""
echo -e "${BLUE}🌱 Seeding prototype: ${PROTOTYPE_ID}${NC}"
echo ""

# Tables that need prototype-scoped seed data
TABLES=("clients" "diagnoses" "medications" "allergies" "vitals" "warm_line_calls" "referrals" "care_journey_events")

for TABLE in "${TABLES[@]}"; do
  echo -n "  Copying ${TABLE}... "

  # Fetch seed rows for this table
  SEED_ROWS=$(curl -s \
    "${SUPABASE_URL}/rest/v1/${TABLE}?prototype_id=eq.seed" \
    -H "apikey: ${SUPABASE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_KEY}" \
    -H "Accept: application/json")

  if [ "$SEED_ROWS" == "[]" ] || [ -z "$SEED_ROWS" ]; then
    echo -e "${YELLOW}(no seed rows)${NC}"
    continue
  fi

  # Re-insert with new prototype_id and fresh IDs (append timestamp to avoid PK collisions)
  REMAPPED=$(echo "$SEED_ROWS" | python3 -c "
import json, sys, time

rows = json.load(sys.stdin)
proto_id = '${PROTOTYPE_ID}'
ts = str(int(time.time()))

new_rows = []
for row in rows:
    new_row = dict(row)
    new_row['prototype_id'] = proto_id
    # Give each row a new unique ID to avoid primary key conflicts
    if 'id' in new_row:
        new_row['id'] = new_row['id'] + '-' + proto_id
    new_rows.append(new_row)

print(json.dumps(new_rows))
")

  # Insert new rows
  RESULT=$(curl -s -w "\n%{http_code}" \
    -X POST "${SUPABASE_URL}/rest/v1/${TABLE}" \
    -H "apikey: ${SUPABASE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_KEY}" \
    -H "Content-Type: application/json" \
    -H "Prefer: return=minimal" \
    -d "$REMAPPED")

  HTTP_CODE=$(echo "$RESULT" | tail -1)

  if [[ "$HTTP_CODE" == "2"* ]]; then
    COUNT=$(echo "$SEED_ROWS" | python3 -c "import json,sys; print(len(json.load(sys.stdin)))")
    echo -e "${GREEN}✔ ${COUNT} rows${NC}"
  else
    echo -e "${RED}✗ HTTP ${HTTP_CODE}${NC}"
    echo "  Response: $(echo "$RESULT" | head -1)"
  fi
done

echo ""
echo -e "${GREEN}✅ Prototype '${PROTOTYPE_ID}' seeded with base data${NC}"
echo ""
echo "  Prototype writes will be isolated to rows tagged: prototype_id = '${PROTOTYPE_ID}'"
echo "  Reads will return seed rows PLUS any rows this prototype creates."
echo ""
echo "  To reset this prototype's data later, re-run:"
echo "  ./seed-prototype.sh ${PROTOTYPE_ID}"
echo ""
