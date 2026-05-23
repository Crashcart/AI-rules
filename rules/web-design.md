# Web Design Standards

Apply to all web design and frontend work produced by any AI in this system.

## Gold Design System

Every web UI produced here uses the gold palette as its primary aesthetic. Define all values as CSS custom properties on `:root` — never hardcode hex values in component styles.

**Color tokens:**
- `--gold-400: #D4AF37` — primary brand gold
- `--gold-300: #EDD06A` — light accent
- `--gold-500: #B8960C` — deep gold
- `--dark-900: #0D0D0D` — primary background
- `--dark-800: #1C1C1C` — surface
- `--dark-700: #2A2A2A` — elevated surface
- `--dark-500: #363636` — border/divider
- `--text-primary: #F5F0E8` — primary text on dark
- `--text-muted: #8A8070` — secondary/muted text

**Typography:**
- Display headings: Cormorant Garamond (serif) — available from Google Fonts
- Body and UI: Inter (sans-serif) — available from Google Fonts
- System fallbacks: Georgia, serif for display; system-ui, sans-serif for body

## Production-Readiness Checklist [NON-NEGOTIABLE]

Every page or component delivered is production-ready before hand-off. Deliver none of these half-done.

1. **Performance** — zero render-blocking resources; images lazy-loaded; CSS/JS inlined or deferred; target Lighthouse performance score ≥ 95
2. **Accessibility** — WCAG 2.1 AA minimum: semantic HTML landmarks, all interactive elements keyboard-accessible, color contrast ≥ 4.5:1, `aria-label` on icon-only controls, `aria-hidden` on decorative SVGs
3. **Responsive** — mobile-first layout; breakpoints defined by content not device; test at 375px, 768px, 1280px minimum
4. **Reduced motion** — all CSS animations and transitions wrapped in `@media (prefers-reduced-motion: no-preference)`; provide static fallback for every animated state
5. **SVG-first graphics** — use inline SVG for all UI graphics, icons, and illustrations; no raster PNG/JPG for decorative or iconographic elements; SVGs use `currentColor` and CSS custom properties for theming
6. **Semantic structure** — `<header>`, `<main>`, `<nav>`, `<section aria-labelledby>`, `<footer>`; one `<h1>` per page; heading hierarchy enforced (no skipped levels)
7. **No inline styles** — all styling via CSS custom properties and class selectors; no `style=""` attributes except for dynamic values set by JavaScript (e.g., scroll-driven transforms)
8. **Scroll behavior** — IntersectionObserver for scroll-triggered reveals; `will-change: transform` declared before animating; no scroll event listeners polling at 60fps
9. **Font loading** — system font stack fallback defined before web fonts load; `font-display: swap` on all `@font-face`; `preconnect` for external font CDN
10. **Self-contained output** — deliver working HTML/CSS/JS files; no unexplained external dependencies; all asset paths verified before hand-off

## SVG Graphics Policy

Produce all graphics as inline SVG. This covers: logos, icons, hero illustrations, background patterns, chart decorations, product mockups. Reasons:
- Scales perfectly at every resolution
- Themeable via CSS custom properties and `currentColor`
- Zero file weight for geometric/icon graphics
- No network requests for decorative elements

When producing SVG, use semantic structure: `<title>` for accessible name, `aria-hidden="true"` for decorative elements, grouped paths via `<g>` with meaningful IDs.

## Demo Reference

`demo/web-design-showcase.html` — reference implementation of the gold luxury aesthetic for the fictional "AURUM — Digital Craft Studio." Use it as a pattern library for:
- Design token setup (`:root` CSS custom properties)
- SVG icon and illustration construction
- Scroll-reveal with IntersectionObserver
- CSS marquee animation
- Nav backdrop blur on scroll
- Responsive grid layout
- Full production page structure

[NON-NEGOTIABLE for gold palette and SVG-first graphics; DEFAULT overridable for individual checklist items where user specifies otherwise]
