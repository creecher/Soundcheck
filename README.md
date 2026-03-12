# 🎙 Soundcheck

A local-first prototyping environment for rapid design exploration.
Built with HTML, CSS, JS, Tailwind, and Font Awesome Pro.
Powered by Claude Code.

---

## Getting Started

### 1. Clone this repo
```bash
git clone https://github.com/YOUR_USERNAME/soundcheck.git
cd soundcheck
```

### 2. Make scripts executable (first time only)
```bash
chmod +x new-prototype.sh save-prototype.sh
```

### 3. Start a new prototype
```bash
./new-prototype.sh your-feature-name
```

This will:
- Pull the latest from `main`
- Create a new branch `prototype/your-feature-name`
- Open the project in VS Code

### 4. Fill in your brief
Open `BRIEF.md` and fill in the problem context before you start building.

### 5. Open Claude Code and start building
```bash
claude
```

Say: *"Read BRIEF.md and let's plan the prototype together before writing any code."*

### 6. Save and share
```bash
./save-prototype.sh
```

This commits, pushes, and prints your live GitHub Pages URL.

---

## File Structure

```
prototype-playground/
├── index.html          ← base prototype template
├── css/
│   └── theme.css       ← design tokens (DO NOT edit per-prototype)
├── js/
│   └── app.js          ← prototype JS
├── CLAUDE.md           ← persistent Claude Code context
├── BRIEF.md            ← per-prototype problem brief (fill in before building)
├── new-prototype.sh    ← creates a new prototype branch
├── save-prototype.sh   ← commits, pushes, prints live URL
└── README.md           ← this file
```

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
<p class="caption">Caption</p>
<span class="overline">Overline</span>
```

### Cards
```html
<div class="card">Content</div>
<div class="card card-sm">Compact card</div>
```

### Badges
```html
<span class="badge">Default</span>
<span class="badge badge-green">Success</span>
<span class="badge badge-red">Error</span>
```

### Icons (Font Awesome Pro)
```html
<i class="fa-regular fa-plus"></i>
<i class="fa-regular fa-magnifying-glass"></i>
<i class="fa-solid fa-check"></i>
```

### Colors (CSS variables)
```css
var(--mauve-12)   /* near-black, primary text */
var(--mauve-9)    /* muted text */
var(--mauve-6)    /* borders */
var(--mauve-3)    /* subtle backgrounds */
var(--blue-9)     /* info / link */
var(--green-9)    /* success */
var(--red-9)      /* destructive */
```

---

## Rules

- These are **not production prototypes** — speed over perfection
- One branch per prototype
- `CLAUDE.md` and `theme.css` live on `main` and are inherited by every branch
- Fill in `BRIEF.md` before every session — it makes Claude 10x more useful
- Share GitHub Pages links with stakeholders, not Figma files
