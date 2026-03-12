// =============================================
// db.js — Soundcheck Data Layer
// Chorus Prototype Playground
//
// PROTOTYPE ISOLATION
// -------------------
// Every write is automatically tagged with the current prototype_id
// (read from <meta name="prototype-id"> in the page head).
// Every read returns rows from the seed data (prototype_id = 'seed')
// PLUS any rows created by this specific prototype.
//
// This means multiple designers can work simultaneously in the same
// Supabase project without stepping on each other's data.
//
// PROTOTYPE ISOLATION — automatic, no action needed
// db.js reads the <meta name="prototype-id"> tag that new-prototype.sh injects.
// All reads return seed data + rows this prototype wrote. All writes are tagged.
// You never need to think about prototype_id — the data layer handles it.
//
// Usage in any prototype:
//   <script src="../js/db.js"></script>
//   const clients = await db.clients.list();
//   const client  = await db.clients.get('CL-005');
// =============================================

// ----- CONFIGURATION -----
const SUPABASE_URL      = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';

// ----- PROTOTYPE IDENTITY -----
// Reads the current prototype name from the page meta tag.
// new-prototype.sh injects this automatically when creating a branch.
// Falls back to 'dev' for local testing without a branch.
function getCurrentPrototype() {
  const meta = document.querySelector('meta[name="prototype-id"]');
  return meta ? meta.getAttribute('content') : 'dev';
}

// Builds the prototype scope filter.
// Returns seed rows PLUS anything this prototype has written.
function protoFilter() {
  const id = getCurrentPrototype();
  if (id === 'seed') return 'prototype_id=eq.seed';
  return `prototype_id=in.(seed,${encodeURIComponent(id)})`;
}

// ----- INTERNAL HELPERS -----
async function _fetch(table, params = '') {
  const url = `${SUPABASE_URL}/rest/v1/${table}${params ? '?' + params : ''}`;
  const res = await fetch(url, {
    headers: {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
      'Content-Type': 'application/json',
      'Prefer': 'return=representation'
    }
  });
  if (!res.ok) throw new Error(`DB error on ${table}: ${res.statusText}`);
  return res.json();
}

// Scoped read: seed + current prototype rows
function query(table, params = '') {
  const pf = protoFilter();
  const full = params ? `${params}&${pf}` : pf;
  return _fetch(table, full);
}

// Unscoped read: for reference tables (programs, staff) that are shared globally
function queryUnscoped(table, params = '') {
  return _fetch(table, params);
}

// Insert: always tags the row with the current prototype_id
async function insert(table, data) {
  const url = `${SUPABASE_URL}/rest/v1/${table}`;
  const payload = { ...data, prototype_id: getCurrentPrototype() };
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
      'Content-Type': 'application/json',
      'Prefer': 'return=representation'
    },
    body: JSON.stringify(payload)
  });
  if (!res.ok) throw new Error(`Insert error on ${table}: ${res.statusText}`);
  return res.json();
}

// Update: patch an existing row by id
async function update(table, id, data) {
  const url = `${SUPABASE_URL}/rest/v1/${table}?id=eq.${id}`;
  const res = await fetch(url, {
    method: 'PATCH',
    headers: {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
      'Content-Type': 'application/json',
      'Prefer': 'return=representation'
    },
    body: JSON.stringify(data)
  });
  if (!res.ok) throw new Error(`Update error on ${table}: ${res.statusText}`);
  return res.json();
}

// ----- PUBLIC API -----
const db = {

  // --- CLIENTS ---
  clients: {
    list: (programId) => {
      const filter = programId ? `program_id=eq.${programId}&` : '';
      return query('clients', `${filter}order=last_name.asc`);
    },
    get: (id) => query('clients', `id=eq.${id}`).then(r => r[0]),
    getHighRisk: () => query('clients', `risk_level=in.(high,crisis)&order=last_name.asc`),
    search: (term) => query('clients', `or=(first_name.ilike.*${term}*,last_name.ilike.*${term}*)&order=last_name.asc`),
    create: (data) => insert('clients', { id: `CL-${Date.now()}`, ...data }),
    update: (id, data) => update('clients', id, { ...data, updated_at: new Date().toISOString() }),
  },

  // --- STAFF --- (shared reference data, not prototype-scoped)
  staff: {
    list: () => queryUnscoped('staff', 'order=name.asc'),
    get: (id) => queryUnscoped('staff', `id=eq.${id}`).then(r => r[0]),
    byProgram: (programId) => queryUnscoped('staff', `program_id=eq.${programId}&order=name.asc`),
  },

  // --- PROGRAMS --- (shared reference data, not prototype-scoped)
  programs: {
    list: () => queryUnscoped('programs', 'order=name.asc'),
    get: (id) => queryUnscoped('programs', `id=eq.${id}`).then(r => r[0]),
  },

  // --- DIAGNOSES ---
  diagnoses: {
    forClient: (clientId) => query('diagnoses', `client_id=eq.${clientId}&order=diagnosed_date.desc`),
    current:   (clientId) => query('diagnoses', `client_id=eq.${clientId}&status=eq.current&order=diagnosed_date.desc`),
    past:      (clientId) => query('diagnoses', `client_id=eq.${clientId}&status=eq.past&order=diagnosed_date.desc`),
  },

  // --- MEDICATIONS ---
  medications: {
    forClient: (clientId) => query('medications', `client_id=eq.${clientId}&order=medication_name.asc`),
    missed:    (clientId) => query('medications', `client_id=eq.${clientId}&status=eq.missed`),
    active:    (clientId) => query('medications', `client_id=eq.${clientId}&status=eq.active`),
  },

  // --- ALLERGIES ---
  allergies: {
    forClient: (clientId) => query('allergies', `client_id=eq.${clientId}&order=severity.asc`),
  },

  // --- VITALS ---
  vitals: {
    forClient: (clientId) => query('vitals', `client_id=eq.${clientId}&order=recorded_at.desc`),
    latest:    (clientId) => query('vitals', `client_id=eq.${clientId}&order=recorded_at.desc&limit=3`),
  },

  // --- WARM LINE CALLS ---
  calls: {
    list: () => query('warm_line_calls', 'order=created_at.desc'),
    forClient:     (clientId) => query('warm_line_calls', `client_id=eq.${clientId}&order=created_at.desc`),
    byPriority:    (priority) => query('warm_line_calls', `priority=eq.${priority}&order=created_at.desc`),
    needsFollowUp: ()         => query('warm_line_calls', 'follow_up_required=eq.true&order=created_at.desc'),
    create: (data) => insert('warm_line_calls', {
      id: `call-${Date.now()}`,
      created_at: new Date().toISOString(),
      ...data
    }),
  },

  // --- REFERRALS ---
  referrals: {
    list: () => query('referrals', 'order=created_at.desc'),
    forClient:  (clientId) => query('referrals', `client_id=eq.${clientId}&order=created_at.desc`),
    byStatus:   (status)   => query('referrals', `status=eq.${status}&order=created_at.desc`),
    pending:    ()         => query('referrals', 'status=eq.pending&order=created_at.desc'),
    inProgress: ()         => query('referrals', 'status=eq.in-progress&order=created_at.desc'),
    create: (data) => insert('referrals', {
      id: `ref-${Date.now()}`,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
      ...data
    }),
    markComplete: (id) => update('referrals', id, {
      status: 'completed',
      updated_at: new Date().toISOString()
    }),
  },

  // --- CARE JOURNEY ---
  journey: {
    forClient: (clientId) => query('care_journey_events', `client_id=eq.${clientId}&order=created_at.asc`),
    current:   (clientId) => query('care_journey_events', `client_id=eq.${clientId}&is_current=eq.true`).then(r => r[0]),
    addEvent:  (data)     => insert('care_journey_events', {
      id: `evt-${Date.now()}`,
      created_at: new Date().toISOString(),
      ...data
    }),
  },

  // --- DASHBOARD HELPERS ---
  dashboard: {
    async summary() {
      const pf = protoFilter();
      const [clients, calls, referrals] = await Promise.all([
        _fetch('clients',         `select=id,risk_level&${pf}`),
        _fetch('warm_line_calls', `created_at=gte.${new Date().toISOString().split('T')[0]}&select=id&${pf}`),
        _fetch('referrals',       `status=eq.pending&select=id&${pf}`),
      ]);
      return {
        activeClients:    clients.length,
        todaysCalls:      calls.length,
        pendingReferrals: referrals.length,
        highRiskClients:  clients.filter(c => c.risk_level === 'high' || c.risk_level === 'crisis').length,
      };
    }
  },

  // --- DEBUG HELPERS ---
  debug: {
    whoami: () => console.log(`🎙 Prototype: "${getCurrentPrototype()}"`),
    myRows: async (table) => {
      const id = getCurrentPrototype();
      const rows = await _fetch(table, `prototype_id=eq.${id}`);
      console.table(rows);
      return rows;
    },
  }
};

window.db = db;

const _pid = getCurrentPrototype();
console.log(`🎙 Soundcheck db.js — prototype: "${_pid}" | reads: seed + ${_pid}`);
