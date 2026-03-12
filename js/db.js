// =============================================
// db.js — Soundcheck Data Layer
// Chorus Prototype Playground
//
// This file abstracts all data access.
// In prototypes, it talks to Supabase.
// In production, swap these methods for real Chorus API calls.
//
// Usage in any prototype:
//   <script src="../js/db.js"></script>
//   const clients = await db.clients.list();
//   const client  = await db.clients.get('CL-005');
// =============================================

// ----- CONFIGURATION -----
// Replace with your Supabase project values
// Get these from: Supabase Dashboard → Project Settings → API
const SUPABASE_URL = "https://iucbtuornluyqtnklcvt.supabase.co";
const SUPABASE_ANON_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1Y2J0dW9ybmx1eXF0bmtsY3Z0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNzA3NjYsImV4cCI6MjA4ODg0Njc2Nn0.Uf15gPU_g3EKBzDNRoI83JjJ0J6Z1thO5lfF7xIntNo";

// ----- INTERNAL FETCH HELPER -----
async function query(table, params = "") {
  const url = `${SUPABASE_URL}/rest/v1/${table}${params ? "?" + params : ""}`;
  const res = await fetch(url, {
    headers: {
      apikey: SUPABASE_ANON_KEY,
      Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
    },
  });
  if (!res.ok) throw new Error(`DB error on ${table}: ${res.statusText}`);
  return res.json();
}

async function insert(table, data) {
  const url = `${SUPABASE_URL}/rest/v1/${table}`;
  const res = await fetch(url, {
    method: "POST",
    headers: {
      apikey: SUPABASE_ANON_KEY,
      Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(`Insert error on ${table}: ${res.statusText}`);
  return res.json();
}

async function update(table, id, data) {
  const url = `${SUPABASE_URL}/rest/v1/${table}?id=eq.${id}`;
  const res = await fetch(url, {
    method: "PATCH",
    headers: {
      apikey: SUPABASE_ANON_KEY,
      Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error(`Update error on ${table}: ${res.statusText}`);
  return res.json();
}

// ----- PUBLIC API -----
// This is the interface prototypes use.
// Method names mirror what a real Chorus API would expose.
const db = {
  // --- CLIENTS ---
  clients: {
    list: (programId) => {
      const filter = programId ? `program_id=eq.${programId}&` : "";
      return query("clients", `${filter}order=last_name.asc`);
    },
    get: (id) => query("clients", `id=eq.${id}`).then((r) => r[0]),
    getHighRisk: () =>
      query("clients", `risk_level=in.(high,crisis)&order=last_name.asc`),
    search: (term) =>
      query(
        "clients",
        `or=(first_name.ilike.*${term}*,last_name.ilike.*${term}*)&order=last_name.asc`,
      ),
    create: (data) => insert("clients", { id: `CL-${Date.now()}`, ...data }),
    update: (id, data) =>
      update("clients", id, { ...data, updated_at: new Date().toISOString() }),
  },

  // --- STAFF ---
  staff: {
    list: () => query("staff", "order=name.asc"),
    get: (id) => query("staff", `id=eq.${id}`).then((r) => r[0]),
    byProgram: (programId) =>
      query("staff", `program_id=eq.${programId}&order=name.asc`),
  },

  // --- PROGRAMS ---
  programs: {
    list: () => query("programs", "order=name.asc"),
    get: (id) => query("programs", `id=eq.${id}`).then((r) => r[0]),
  },

  // --- DIAGNOSES ---
  diagnoses: {
    forClient: (clientId) =>
      query("diagnoses", `client_id=eq.${clientId}&order=diagnosed_date.desc`),
    current: (clientId) =>
      query(
        "diagnoses",
        `client_id=eq.${clientId}&status=eq.current&order=diagnosed_date.desc`,
      ),
    past: (clientId) =>
      query(
        "diagnoses",
        `client_id=eq.${clientId}&status=eq.past&order=diagnosed_date.desc`,
      ),
  },

  // --- MEDICATIONS ---
  medications: {
    forClient: (clientId) =>
      query(
        "medications",
        `client_id=eq.${clientId}&order=medication_name.asc`,
      ),
    missed: (clientId) =>
      query("medications", `client_id=eq.${clientId}&status=eq.missed`),
    active: (clientId) =>
      query("medications", `client_id=eq.${clientId}&status=eq.active`),
  },

  // --- ALLERGIES ---
  allergies: {
    forClient: (clientId) =>
      query("allergies", `client_id=eq.${clientId}&order=severity.asc`),
  },

  // --- VITALS ---
  vitals: {
    forClient: (clientId) =>
      query("vitals", `client_id=eq.${clientId}&order=recorded_at.desc`),
    latest: (clientId) =>
      query(
        "vitals",
        `client_id=eq.${clientId}&order=recorded_at.desc&limit=3`,
      ),
  },

  // --- WARM LINE CALLS ---
  calls: {
    list: () => query("warm_line_calls", "order=created_at.desc"),
    forClient: (clientId) =>
      query(
        "warm_line_calls",
        `client_id=eq.${clientId}&order=created_at.desc`,
      ),
    byPriority: (priority) =>
      query("warm_line_calls", `priority=eq.${priority}&order=created_at.desc`),
    needsFollowUp: () =>
      query(
        "warm_line_calls",
        "follow_up_required=eq.true&order=created_at.desc",
      ),
    create: (data) =>
      insert("warm_line_calls", { id: `call-${Date.now()}`, ...data }),
  },

  // --- REFERRALS ---
  referrals: {
    list: () => query("referrals", "order=created_at.desc"),
    forClient: (clientId) =>
      query("referrals", `client_id=eq.${clientId}&order=created_at.desc`),
    byStatus: (status) =>
      query("referrals", `status=eq.${status}&order=created_at.desc`),
    pending: () =>
      query("referrals", "status=eq.pending&order=created_at.desc"),
    inProgress: () =>
      query("referrals", "status=eq.in-progress&order=created_at.desc"),
    create: (data) =>
      insert("referrals", {
        id: `ref-${Date.now()}`,
        ...data,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      }),
    markComplete: (id) =>
      update("referrals", id, {
        status: "completed",
        updated_at: new Date().toISOString(),
      }),
  },

  // --- CARE JOURNEY ---
  journey: {
    forClient: (clientId) =>
      query(
        "care_journey_events",
        `client_id=eq.${clientId}&order=created_at.asc`,
      ),
    current: (clientId) =>
      query(
        "care_journey_events",
        `client_id=eq.${clientId}&is_current=eq.true`,
      ).then((r) => r[0]),
    addEvent: (data) =>
      insert("care_journey_events", { id: `evt-${Date.now()}`, ...data }),
  },

  // --- DASHBOARD HELPERS ---
  // Convenience methods that mirror what a dashboard would need
  dashboard: {
    async summary() {
      const [clients, calls, referrals] = await Promise.all([
        query("clients", "select=id,risk_level"),
        query(
          "warm_line_calls",
          `created_at=gte.${new Date().toISOString().split("T")[0]}&select=id`,
        ),
        query("referrals", "status=eq.pending&select=id"),
      ]);
      return {
        activeClients: clients.length,
        todaysCalls: calls.length,
        pendingReferrals: referrals.length,
        highRiskClients: clients.filter(
          (c) => c.risk_level === "high" || c.risk_level === "crisis",
        ).length,
      };
    },
  },
};

// Make db available globally
window.db = db;

console.log("🎙 Soundcheck db.js loaded — Chorus data layer ready");
