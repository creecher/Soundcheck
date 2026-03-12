# Setting Up Supabase for Soundcheck

This guide takes about 10 minutes. You only need to do this once.

---

## Step 1 — Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and sign up (free, no credit card)
2. Click **New Project**
3. Name it `soundcheck`
4. Choose a region close to you (US East or US West)
5. Set a database password (save it somewhere safe)
6. Click **Create new project** and wait ~2 minutes for it to spin up

---

## Step 2 — Run the schema

1. In your Supabase project, click **SQL Editor** in the left nav
2. Click **New query**
3. Open `data/schema.sql` from this repo
4. Paste the entire contents into the SQL editor
5. Click **Run**
6. You should see: `Success. No rows returned`

---

## Step 3 — Seed the mock data

1. Click **New query** again in the SQL editor
2. Open `data/seed.sql` from this repo
3. Paste the entire contents into the SQL editor
4. Click **Run**
5. You should see: `Success. No rows returned`

To verify, click **Table Editor** in the left nav — you should see all 10 tables populated with data.

---

## Step 4 — Get your API keys

1. In your Supabase project, go to **Project Settings** (gear icon) → **API**
2. Copy two values:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon public key** — a long JWT string

---

## Step 5 — Add your keys to db.js

Open `js/db.js` and replace the placeholder values at the top:

```javascript
const SUPABASE_URL      = 'https://your-project-id.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key-here';
```

---

## Step 6 — Test it

Open `index.html` in your browser, open the browser console, and run:

```javascript
const clients = await db.clients.list();
console.log(clients);
```

You should see the 7 mock clients returned.

---

## Using the data layer in prototypes

Any prototype can access data by including `db.js` before `app.js`:

```html
<script src="js/db.js"></script>
<script src="js/app.js"></script>
```

Then in your prototype JS:

```javascript
// Load all clients
const clients = await db.clients.list();

// Get a specific client
const client = await db.clients.get('CL-005');

// Get high risk clients
const highRisk = await db.clients.getHighRisk();

// Get dashboard summary numbers
const summary = await db.dashboard.summary();
// → { activeClients: 7, todaysCalls: 2, pendingReferrals: 1, highRiskClients: 3 }

// Log a warm line call
await db.calls.create({
  client_id: 'CL-003',
  caller_name: 'Jennifer Lee',
  phone: '(555) 345-6789',
  relationship: 'self',
  priority: 'routine',
  summary: 'Requesting therapy resources',
  outcome: 'Resource list provided',
  follow_up_required: true,
  handled_by: 'staff-001',
  duration_minutes: 18
});

// Create a referral
await db.referrals.create({
  client_id: 'CL-003',
  from_program: 'prog-warm-line',
  to_program: 'prog-central-intake',
  urgency: 'routine',
  reason: 'Intake assessment needed',
  created_by: 'staff-001'
});
```

---

## Notes

- The anon key is safe to use in frontend code — it's designed for this
- Row Level Security is enabled but set to open for prototyping
- If you need to reset the data, re-run `seed.sql` (delete existing rows first or use `TRUNCATE`)
- The free tier gives you 500MB storage and 2GB bandwidth — more than enough for prototyping

---

## When real Chorus APIs exist

Update the methods in `js/db.js` to point at real endpoints.
The method signatures stay the same — prototypes won't need to change.
That's the whole point of the abstraction layer.
