# CLAUDE.md — Soundcheck

This file is read automatically by Claude Code at the start of every session.
It defines the rules, stack, and expectations for Soundcheck — Chorus's design prototype playground.

---

## What This Is

**Soundcheck** is Chorus's design prototype playground — not a production codebase.
Prototypes exist to communicate ideas to stakeholders and inform engineering.
Speed and visual accuracy matter more than code quality.

---

## Stack

- **HTML / Vanilla JS** — no build step, no bundler
- **Tailwind CSS** — loaded via CDN for utility classes
- **shadcn/ui** — the ONLY component library; load via CDN (unpkg or jsDelivr)
- **Font Awesome Pro** — kit: f628cf1eec
- **React** — only if the prototype genuinely needs component interaction; use CDN version
- Everything lives in `index.html` + `css/theme.css` + `js/app.js`

---

## Components — shadcn/ui Only

**Always use shadcn/ui. Never build custom components if a shadcn equivalent exists.**

| Need | Use |
|---|---|
| Containers / panels | `Card`, `CardHeader`, `CardContent`, `CardFooter` |
| Tables of data | `Table`, `TableHeader`, `TableRow`, `TableCell` |
| Status indicators | `Badge` (variants: default, secondary, destructive, outline) |
| Modals / forms | `Dialog`, `DialogTrigger`, `DialogContent` |
| Tab navigation | `Tabs`, `TabsList`, `TabsTrigger`, `TabsContent` |
| Buttons | `Button` (variants: default, outline, ghost, destructive, link) |
| Form inputs | `Input`, `Select`, `Textarea`, `Switch`, `Checkbox` |
| Callouts / warnings | `Alert`, `AlertTitle`, `AlertDescription` |
| Dropdown actions | `DropdownMenu` |
| Hover details | `Tooltip` |
| Loading states | `Skeleton` |
| Notifications | `Toast` / `Sonner` |

---

## Design System Rules

### Typography
- Font: **Figtree** (Google Fonts) — always, never substitute
- Use Tailwind text utilities (`text-sm`, `text-base`, `text-lg`, `text-xl`, etc.)
- Never hard-code font-size in px

### Spacing
- Use Tailwind spacing (`p-2`, `gap-4`, `mt-6`, etc.) — never arbitrary px values
- Scale: p-1=4px, p-2=8px, p-3=12px, p-4=16px, p-6=24px, p-8=32px

### Border Radius
- Use Tailwind: `rounded`, `rounded-lg`, `rounded-xl`, `rounded-2xl`, `rounded-3xl`, `rounded-full`

### Colors — Radix CSS Variables Only

**Never use hex values or Tailwind color classes (blue-500, red-400, etc.).**
**Always use Radix CSS variables from theme.css.**

#### Full Radix palette — 31 scales, 12 steps each:

**Grays** (neutral UI chrome)
- `--gray-N` · `--mauve-N` ← primary neutral · `--slate-N` · `--sage-N` · `--olive-N` · `--sand-N`

**Reds & Pinks**
- `--tomato-N` · `--red-N` ← errors/destructive · `--ruby-N` · `--crimson-N` · `--pink-N` · `--plum-N`

**Purples & Blues**
- `--purple-N` · `--violet-N` ← brand highlights · `--iris-N` · `--indigo-N` · `--blue-N` ← info/links · `--cyan-N`

**Greens & Teals**
- `--teal-N` · `--jade-N` · `--green-N` ← success · `--grass-N` · `--mint-N` · `--lime-N`

**Yellows & Earthy**
- `--yellow-N` ← warnings · `--amber-N` · `--orange-N` ← urgent · `--brown-N` · `--bronze-N` · `--gold-N` · `--sky-N`

#### Step semantics (same on every scale):
- **1–2**: Page/subtle backgrounds
- **3–5**: UI element backgrounds, hover states
- **6–8**: Borders and separators
- **9**: Solid fill — the main color of the scale
- **10**: Hovered solid (slightly darker)
- **11**: Accessible text on white backgrounds
- **12**: High-contrast text, darkest shade

#### Common patterns:
```css
/* Neutral badge */
background: var(--mauve-3); color: var(--mauve-11); border: 1px solid var(--mauve-6);

/* Crisis/error badge */
background: var(--red-3); color: var(--red-11); border: 1px solid var(--red-6);

/* Success badge */
background: var(--green-3); color: var(--green-11); border: 1px solid var(--green-6);

/* Warning badge */
background: var(--yellow-3); color: var(--yellow-11); border: 1px solid var(--yellow-7);

/* Primary button */
background: var(--mauve-12); color: white;

/* Sidebar */
background: var(--mauve-2); border-right: 1px solid var(--mauve-6);

/* Active nav item */
background: var(--blue-3); color: var(--blue-11);
```

### Icons
- **Font Awesome Pro** — `fa-regular` default, `fa-solid` for emphasis
- Keep icons at 14–16px in most contexts

---

## File Structure

```
prototype-name/
├── index.html        ← all markup; imports Tailwind, FA, shadcn, theme.css
├── css/
│   └── theme.css     ← Radix CSS variables (DO NOT EDIT per prototype)
├── js/
│   ├── db.js         ← Supabase data layer (DO NOT EDIT)
│   └── app.js        ← prototype-specific logic only
├── CLAUDE.md         ← this file
└── BRIEF.md          ← per-prototype context (fill in before building)
```
---

## Data Isolation — How Prototype Scoping Works

**Claude does not need to manage prototype_id. The data layer handles it automatically.**

When `new-prototype.sh` creates a branch, it:
1. Sets `<meta name="prototype-id" content="feature-name">` in `index.html`
2. Runs `seed-prototype.sh` to copy the base seed data into the prototype's scope

`db.js` then:
- **Reads** return rows where `prototype_id = 'seed'` OR `prototype_id = 'feature-name'`
- **Writes** automatically tag every new row with `prototype_id = 'feature-name'`

This means five designers can work in the same Supabase project simultaneously without collisions.

**What this means for Claude when building prototypes:**
- Use `db.js` methods exactly as documented — scoping is invisible
- Do NOT add `prototype_id` to any data objects manually — it will be added automatically
- Do NOT filter by `prototype_id` in queries — `db.js` already does this
- If debugging data issues, use `db.debug.whoami()` and `db.debug.myRows('table_name')` in the browser console



---


---

## db.js — Full Method Reference

All data comes from `db.js`. Never hardcode data values. Every method returns a Promise — always use `await`.

```javascript
// DASHBOARD
await db.dashboard.summary()
// → { activeClients, todaysCalls, pendingReferrals, highRiskClients }

// CLIENTS
await db.clients.list()                        // all clients, sorted by last name
await db.clients.list('prog-warm-line')        // clients in a specific program
await db.clients.get('CL-001')                 // single client by ID
await db.clients.getHighRisk()                 // clients where risk = high or crisis
await db.clients.search('rodriguez')           // search by first or last name
await db.clients.create({ first_name, last_name, program_id, risk_level, ... })
await db.clients.update('CL-001', { risk_level: 'high' })

// STAFF (shared reference data — not prototype-scoped)
await db.staff.list()                          // all staff
await db.staff.get('staff-001')                // single staff member
await db.staff.byProgram('prog-warm-line')     // staff assigned to a program

// PROGRAMS (shared reference data — not prototype-scoped)
await db.programs.list()                       // all three programs
await db.programs.get('prog-warm-line')        // single program

// REFERRALS
await db.referrals.list()                      // all referrals, newest first
await db.referrals.pending()                   // status = pending
await db.referrals.inProgress()                // status = in-progress
await db.referrals.forClient('CL-001')         // referrals for a specific client
await db.referrals.byStatus('completed')       // filter by any status
await db.referrals.create({ client_id, from_program, to_program, urgency, reason, created_by })
await db.referrals.markComplete('ref-001')     // mark a referral completed

// WARM LINE CALLS
await db.calls.list()                          // all calls, newest first
await db.calls.forClient('CL-001')             // calls linked to a client
await db.calls.byPriority('crisis')            // filter by priority (routine/urgent/crisis)
await db.calls.needsFollowUp()                 // calls where follow_up_required = true
await db.calls.create({ caller_name, phone, relationship, priority, summary, handled_by, duration_minutes })

// DIAGNOSES
await db.diagnoses.forClient('CL-001')         // all diagnoses for a client
await db.diagnoses.current('CL-001')           // status = current only
await db.diagnoses.past('CL-001')              // status = past only

// MEDICATIONS
await db.medications.forClient('CL-001')       // all medications
await db.medications.active('CL-001')          // status = active
await db.medications.missed('CL-001')          // status = missed

// ALLERGIES
await db.allergies.forClient('CL-001')         // all allergies for a client

// VITALS
await db.vitals.forClient('CL-001')            // all vitals, newest first
await db.vitals.latest('CL-001')               // most recent 3 vitals

// CARE JOURNEY
await db.journey.forClient('CL-001')           // all events, chronological
await db.journey.current('CL-001')             // the current/active event
await db.journey.addEvent({ client_id, event_type, title, program_id, performed_by, note })
```

### Known IDs — safe to hardcode in prototypes

**Clients:** CL-001 (Michael Rodriguez) · CL-002 (Maria Rodriguez) · CL-003 (Jennifer Lee) · CL-004 (Robert Thompson) · CL-005 (Carlos Sanchez) · CL-006 (Linda Garcia) · CL-007 (Sarah Johnson)

**Staff:** staff-001 (Mark Thompson) · staff-002 (Lisa Martinez) · staff-003 (Jane Smith) · staff-004 (Dr. Emily Chen) · staff-005 (David Nguyen)

**Programs:** prog-warm-line · prog-central-intake · prog-care-facility

## What Claude Should Do

- Read `BRIEF.md` before writing any code
- Ask clarifying questions if the brief is vague
- Use **shadcn/ui** for all standard UI patterns
- Use **Radix CSS variables** for all colors
- Use **Tailwind spacing** — never arbitrary px values
- Use **Figtree** font exclusively
- Use realistic placeholder content — Chorus product domain, not Lorem ipsum
- Add comments to explain non-obvious prototype logic

## What Claude Should NOT Do

- Do not install npm packages or create a build pipeline
- Do not build custom card, badge, button, table, or modal components
- Do not use hex colors or Tailwind color classes (text-blue-500, bg-red-400)
- Do not use arbitrary spacing values
- Do not create separate component files
- Do not optimize for performance
- Do not add complex error handling — fake it if needed

---

## Sharing Prototypes

Run `./save-prototype.sh` to commit, push, deploy to GitHub Pages, and copy the URL.

URL format: `https://creecher.github.io/Soundcheck/[branch-name]/`

---

## Reminder

These prototypes are **throwaway artifacts**. Their only job is to communicate
a design idea clearly enough for stakeholders to react and engineers to understand.
Done and shareable beats perfect and stuck.
