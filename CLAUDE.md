# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

**Soundcheck** is Chorus's design prototype playground — not a production codebase.
Prototypes exist to communicate ideas to stakeholders and inform engineering.
Speed and visual accuracy matter more than code quality.

---

## Workflow Commands

```bash
./new-prototype.sh <feature-name>   # pull main, create prototype/<feature-name> branch, seed data, open VS Code
./save-prototype.sh                 # git add ., commit, push, print GitHub Pages URL
./seed-prototype.sh <prototype-id>  # (called by new-prototype.sh) copies seed rows into prototype scope
```

Every new prototype lives on its own branch (`prototype/<feature-name>`). Never commit directly to `main`.

`CLAUDE.md` and `css/theme.css` live on `main` and are inherited by every branch — don't edit them per-prototype.

`backstage.html` (on main) is a live design system cheatsheet — open it in a browser to see all colors, components, and icons.

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
Tailwind is configured with custom aliases (use these instead of default Tailwind radius names):

| Class | Value |
|---|---|
| `rounded-border` | 4px |
| `rounded-xsm` | 8px |
| `rounded-sm` | 12px |
| `rounded-md` | 16px |
| `rounded-lg` | 24px |
| `rounded-full` | 999px |

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

## db.js API Reference

All methods return Promises. Include `<script src="../js/db.js"></script>` in `index.html` to use `window.db`.

```javascript
// Clients (prototype-scoped)
db.clients.list(programId?)          // all clients, optional filter by program
db.clients.get('CL-005')             // single client
db.clients.getHighRisk()             // risk_level in (high, crisis)
db.clients.search('term')            // name search
db.clients.create(data)              // auto-generates id: CL-{timestamp}
db.clients.update(id, data)          // patches + sets updated_at

// Staff & Programs (shared reference data — NOT prototype-scoped)
db.staff.list()
db.staff.get(id)
db.staff.byProgram(programId)
db.programs.list()
db.programs.get(id)

// Clinical data (prototype-scoped)
db.diagnoses.forClient(clientId)     // all diagnoses
db.diagnoses.current(clientId)       // status = current
db.diagnoses.past(clientId)
db.medications.forClient(clientId)
db.medications.missed(clientId)
db.medications.active(clientId)
db.allergies.forClient(clientId)
db.vitals.forClient(clientId)
db.vitals.latest(clientId)           // last 3 readings

// Warm line calls (prototype-scoped)
db.calls.list()
db.calls.forClient(clientId)
db.calls.byPriority(priority)
db.calls.needsFollowUp()
db.calls.create(data)                // auto-generates id: call-{timestamp}

// Referrals (prototype-scoped)
db.referrals.list()
db.referrals.forClient(clientId)
db.referrals.byStatus(status)
db.referrals.pending()
db.referrals.inProgress()
db.referrals.create(data)            // auto-generates id: ref-{timestamp}
db.referrals.markComplete(id)

// Care journey (prototype-scoped)
db.journey.forClient(clientId)
db.journey.current(clientId)         // is_current = true
db.journey.addEvent(data)            // auto-generates id: evt-{timestamp}

// Dashboard
db.dashboard.summary()
// → { activeClients, todaysCalls, pendingReferrals, highRiskClients }

// Debug (browser console only)
db.debug.whoami()                    // prints current prototype ID
db.debug.myRows('table_name')        // console.table of this prototype's rows
```

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
