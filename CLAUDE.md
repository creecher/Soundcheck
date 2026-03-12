# CLAUDE.md — Soundcheck

This file is read automatically by Claude Code at the start of every session.
It defines the rules, stack, and expectations for Soundcheck — Chorus's design prototype playground.

---

## What This Is

**Soundcheck** is Chorus's design prototype playground — not a production codebase.
Prototypes here exist to communicate ideas to stakeholders and inform engineering.
They do not need to be perfect, scalable, or production-ready.
Speed and visual accuracy matter more than code quality.

---

## Stack

- **HTML / CSS / Vanilla JS** — no build step, no bundler, no framework overhead
- **Tailwind CSS** — loaded via CDN for utility classes
- **Font Awesome Pro** — loaded via kit CDN for icons (kit: f628cf1eec)
- **React** — only if the prototype genuinely needs component interaction; use CDN version
- Everything lives in a single `index.html` + `css/theme.css` + `js/app.js`

---

## Design System Rules

### Typography
- Font: **Figtree** (Google Fonts) — always use this, never substitute
- Headings: font-weight 600 (Semibold)
- Body / Caption: font-weight 400 (Regular)
- Use the `.h1–.h6`, `.body-1`, `.body-2`, `.caption`, `.overline`, `.subtitle-1`, `.subtitle-2` classes from theme.css
- Never invent font sizes — always pull from the type scale

### Spacing
- 4px base grid: 0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96, 128px
- Use CSS variables: `var(--space-1)` through `var(--space-32)`
- Or Tailwind spacing utilities which are pre-mapped to the same scale

### Border Radius
- Border: 4px (`var(--radius-border)`) — table rows, subtle containers
- XSmall: 8px (`var(--radius-xsmall)`) — small chips, badges
- Small: 12px (`var(--radius-small)`) — buttons, inputs, small cards
- Medium: 16px (`var(--radius-medium)`) — cards, modals
- Large: 24px (`var(--radius-large)`) — large containers, sheets
- Full: 999px (`var(--radius-full)`) — pills, avatars, tags

### Colors
- **Neutral**: Use Mauve scale — `var(--mauve-1)` through `var(--mauve-12)`
- **Mauve-12** is near-black — used for primary button fill and primary text
- **Mauve-9/10/11** are used for muted/secondary text
- **Mauve-4/5/6** are used for borders and subtle backgrounds
- **Accent colors**: Use Radix accent CSS variables (`--blue-9`, `--green-9`, `--red-9`, etc.)
  - Blue = informational
  - Green = success / positive
  - Red = destructive / error
  - Yellow = warning
  - Violet / Purple / Indigo = feature highlights, brand moments
- Never use hex values directly in prototype code — always use the CSS variables

### Buttons
- **Primary** (`.btn.btn-primary`): Mauve-12 fill, white text — main actions
- **Outlined** (`.btn.btn-outlined`): White fill, Mauve-6 border — secondary actions
- **Ghost/Text** (`.btn.btn-ghost`): Transparent, Mauve-11 text — tertiary/inline actions
- Icon + label buttons: use Font Awesome with a gap, e.g. `<i class="fa-regular fa-plus"></i> Add item`

### Icons
- Use **Font Awesome Pro** (kit already loaded)
- Default style: `fa-regular` (outlined) for UI icons
- Use `fa-solid` for emphasis or filled states
- Keep icons at 14–16px in most UI contexts
- Example: `<i class="fa-regular fa-magnifying-glass"></i>`

---

## File Structure

```
prototype-name/
├── index.html        ← all markup, import Tailwind + FA + theme.css
├── css/
│   └── theme.css     ← design tokens, base components (DO NOT EDIT per prototype)
├── js/
│   └── app.js        ← prototype-specific logic only
├── CLAUDE.md         ← this file (inherited from main branch)
└── BRIEF.md          ← per-prototype context (designer fills this in)
```

---

## What Claude Should Do

- Read `BRIEF.md` before writing any code — it contains the problem context
- Ask clarifying questions if the brief is vague before building
- Build in `index.html` — keep it as a single file where possible
- Use `theme.css` classes and CSS variables — do not inline arbitrary styles
- Keep JS simple and readable — no complex state management
- Add comments to explain non-obvious prototype logic
- Use realistic placeholder content (not "Lorem ipsum") — use the product domain
- When generating UI, reference actual Radix color names and spacing values

## What Claude Should NOT Do

- Do not install npm packages or create a build pipeline
- Do not use frameworks unless React is explicitly needed
- Do not create separate component files — keep it in index.html
- Do not use arbitrary colors or font sizes outside the design system
- Do not optimize for performance — this is a prototype
- Do not add complex error handling — fake it if needed

---

## Sharing Prototypes

Run `./save-prototype.sh` from the repo root to:
1. Commit and push the current branch
2. Deploy to GitHub Pages
3. Get a shareable URL copied to your clipboard

URL format: `https://[username].github.io/soundcheck/[branch-name]/`

---

## Reminder

These prototypes are **throwaway artifacts**. Their only job is to communicate
a design idea clearly enough for stakeholders to react and engineers to understand.
Done and shareable beats perfect and stuck.
