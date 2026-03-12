# Supabase Setup — Soundcheck

## Fresh install (never run schema.sql before)

1. Open your Supabase project → SQL Editor → New query
2. Paste and run `schema.sql`
3. Paste and run `seed.sql`
4. Copy your project URL and anon key into `js/db.js`

---

## Existing install (already ran the old schema.sql)

Run the migration to add prototype isolation:

1. Open your Supabase project → SQL Editor → New query
2. Paste and run `migration_add_prototype_id.sql`

That's it. Your existing data is tagged as `prototype_id = 'seed'` and will be visible to all prototypes.

---

## Where to find your credentials

Supabase Dashboard → Project Settings → API:
- **Project URL** → paste as `SUPABASE_URL` in `js/db.js`
- **anon / public key** → paste as `SUPABASE_ANON_KEY` in `js/db.js`

---

## How prototype isolation works

Every row in the writable tables has a `prototype_id` column.

| prototype_id | Meaning |
|---|---|
| `seed` | Base data shared by all prototypes (read-only by convention) |
| `nav-redesign` | Rows created by the `nav-redesign` prototype |
| `intake-flow` | Rows created by the `intake-flow` prototype |

`db.js` automatically:
- **Tags every write** with the current prototype's ID
- **Scopes every read** to return `seed` rows + the current prototype's rows

Designers never touch `prototype_id` directly. It's invisible.

---

## Starting a new prototype

```bash
./new-prototype.sh my-feature-name
```

This creates the branch, injects the prototype ID into `index.html`, and seeds the data.

## Resetting a prototype's data

```bash
./seed-prototype.sh my-feature-name
```

Re-copies the base seed into the prototype's scope. Does not touch seed rows.

## Cleaning up old prototype data

In Supabase SQL Editor:

```sql
-- Remove all rows from a specific prototype
DELETE FROM warm_line_calls     WHERE prototype_id = 'my-feature-name';
DELETE FROM referrals           WHERE prototype_id = 'my-feature-name';
DELETE FROM care_journey_events WHERE prototype_id = 'my-feature-name';
DELETE FROM clients             WHERE prototype_id = 'my-feature-name';
DELETE FROM diagnoses           WHERE prototype_id = 'my-feature-name';
DELETE FROM medications         WHERE prototype_id = 'my-feature-name';
DELETE FROM allergies           WHERE prototype_id = 'my-feature-name';
DELETE FROM vitals              WHERE prototype_id = 'my-feature-name';
```
