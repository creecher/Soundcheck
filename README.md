# 🎙 Soundcheck

Chorus's design prototype playground — a local-first environment for rapid wireframing and stakeholder reviews.
Built with HTML, CSS, JS, Tailwind, and Font Awesome Pro. Powered by Claude Code.

> **Prototypes here are not production code.** They exist to communicate ideas clearly and get alignment fast.

---

## First Time Setup

Do this once when you first join the team.

### 1. Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Clone the repo
```bash
git clone https://github.com/creecher/Soundcheck.git
cd Soundcheck
```

### 3. Make the scripts executable
```bash
chmod +x new-prototype.sh save-prototype.sh
```


---

## Starting a New Prototype

### 1. Create a new branch
```bash
./new-prototype.sh your-feature-name
```
This pulls the latest from `main`, creates a `prototype/your-feature-name` branch, and opens VS Code.

### 2. Fill in your brief
Open `BRIEF.md` and fill in the problem context — paste your Confluence requirements, describe the user flow, list the screens you need.

### 3. Open Claude Code
```bash
claude
```

Start every session with this prompt:
> *"Read CLAUDE.md and BRIEF.md, then let's plan this prototype together before you write any code."*

Claude Code will read your design system rules and brief, ask clarifying questions, and help you plan before building anything.

### 4. Build and iterate
Describe changes, drop in screenshots, ask Claude to adjust. Keep it simple — fake what you don't need.

### 5. Save and share
```bash
./save-prototype.sh
```
This commits, pushes, and prints your live GitHub Pages URL. Share the link with stakeholders — no Figma file needed.

---

## File Structure

```
Soundcheck/
├── index.html              ← base prototype template (start here)
├── CLAUDE.md               ← persistent Claude Code design system rules
├── BRIEF.md                ← fill this in before every prototype session
├── new-prototype.sh        ← creates a new prototype branch
├── save-prototype.sh       ← commits, pushes, prints live URL
├── README.md               ← this file
├── css/
│   └── theme.css           ← design tokens — DO NOT edit per-prototype
├── js/
│   ├── db.js               ← Supabase data layer — add your keys here
│   └── app.js              ← prototype-specific logic
└── data/
    ├── schema.sql          ← Supabase table definitions
    ├── seed.sql            ← Chorus mock data (clients, referrals, staff, etc.)
    └── SUPABASE_SETUP.md   ← step-by-step Supabase setup guide
```

---

## Using Mock Data

Soundcheck is connected to a real Supabase backend with Chorus-flavored mock data. Any prototype can query it directly.

```javascript
// In your prototype JS or browser console:
const clients   = await db.clients.list();
const highRisk  = await db.clients.getHighRisk();
const referrals = await db.referrals.list();
const summary   = await db.dashboard.summary();
// → { activeClients: 7, todaysCalls: 2, pendingReferrals: 1, highRiskClients: 3 }
```

See `data/SUPABASE_SETUP.md` for the full setup guide and `js/db.js` for all available methods.

---

## Design System Quick Reference

### Buttons
```html
<button class="btn btn-primary">Primary</button>
<button class="btn btn-outlined">Secondary</button>
<button class="btn btn-ghost">Ghost</button>
```

### Typography
```html
<h1>Heading 1</h1>
<p class="body-1">Body text</p>
<p class="body-2">Secondary text</p>
<p class="caption">Caption / helper text</p>
<span class="overline">Overline label</span>
```

### Cards
```html
<div class="card">Standard card</div>
<div class="card card-sm">Compact card</div>
```

### Badges
```html
<span class="badge">Default</span>
<span class="badge badge-green">Success</span>
<span class="badge badge-red">Error / Crisis</span>
<span class="badge badge-yellow">Warning</span>
<span class="badge badge-blue">Info</span>
```

### Icons (Font Awesome Pro)
```html
<i class="fa-regular fa-plus"></i>
<i class="fa-regular fa-magnifying-glass"></i>
<i class="fa-regular fa-phone"></i>
<i class="fa-regular fa-circle-exclamation"></i>
<i class="fa-solid fa-check"></i>
```

### Colors (CSS variables)
```css
var(--mauve-12)   /* near-black — primary text, primary button */
var(--mauve-11)   /* dark gray — secondary text */
var(--mauve-9)    /* mid gray — muted text */
var(--mauve-6)    /* light gray — borders */
var(--mauve-3)    /* near-white — subtle backgrounds */
var(--blue-9)     /* info / links */
var(--green-9)    /* success / completed */
var(--red-9)      /* destructive / crisis */
var(--yellow-9)   /* warning */
var(--violet-9)   /* feature highlights */
```

---

## Rules

- These are **not production prototypes** — speed over perfection
- One branch per prototype — branch off `main`, never commit directly to it
- `CLAUDE.md` and `theme.css` live on `main` and are inherited by every branch — don't edit them per-prototype
- Fill in `BRIEF.md` before every Claude Code session — it makes a huge difference
- Share GitHub Pages links with stakeholders, not Figma files
- When a prototype is done, leave the branch — it's the artifact
