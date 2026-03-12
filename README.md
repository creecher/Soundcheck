# 🎙 Soundcheck

Chorus's design prototype playground — a local-first environment for rapid wireframing and stakeholder reviews.
Built with HTML, CSS, JS, Tailwind, shadcn/ui, and Font Awesome Pro. Powered by Claude Code.

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

### 3. Add your Supabase credentials
Open `js/db.js` and set `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
See `data/SUPABASE_SETUP.md` for where to find these.

---

## Starting a New Prototype

### 1. Create a new branch
```bash
./new-prototype.sh your-feature-name
```
This pulls the latest from `main`, creates a `prototype/your-feature-name` branch, seeds your prototype's data, and opens VS Code.

### 2. Fill in your brief
Open `BRIEF.md` and fill in the problem context — paste your Confluence requirements, describe the user flow, list the screens you need.

### 3. Open Claude Code
```bash
claude
```

Start every session with this prompt:
> *"Read CLAUDE.md and BRIEF.md, then let's plan this prototype together before you write any code."*

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
├── backstage.html          ← design token + prompt reference (open in browser)
├── CLAUDE.md               ← persistent Claude Code design system rules
├── BRIEF.md                ← fill this in before every prototype session
├── new-prototype.sh        ← creates a new prototype branch + seeds data
├── save-prototype.sh       ← commits, pushes, prints live URL
├── seed-prototype.sh       ← resets a prototype's data back to baseline
├── README.md               ← this file
├── css/
│   └── theme.css           ← Radix design tokens — DO NOT edit per-prototype
├── js/
│   ├── db.js               ← Supabase data layer — add your keys here
│   └── app.js              ← prototype-specific logic
└── data/
    ├── schema.sql          ← Supabase table definitions (fresh install)
    ├── seed.sql            ← Chorus mock data (clients, referrals, staff, etc.)
    ├── migration_add_prototype_id.sql  ← run if you have an existing install
    └── SUPABASE_SETUP.md   ← step-by-step Supabase setup guide
```

---

## Prototype Data Isolation

Every prototype gets its own copy of the seed data. Writes from one prototype never affect another — multiple designers can work in the same Supabase project simultaneously without collisions.

To reset a prototype's data back to baseline at any time:
```bash
./seed-prototype.sh your-feature-name
```

---

## Reference

Open `backstage.html` in your browser for a full reference of Claude prompts, database methods, color tokens, and typography — everything you need without leaving your browser.

---

## Rules

- These are **throwaway prototypes** — speed over perfection
- One branch per prototype — branch off `main`, never commit directly to it
- `CLAUDE.md` and `theme.css` live on `main` and are inherited by every branch — don't edit them per-prototype
- Fill in `BRIEF.md` before every Claude Code session — it makes a huge difference
- Share GitHub Pages links with stakeholders, not Figma files
- When a prototype is done, leave the branch — it's the artifact
