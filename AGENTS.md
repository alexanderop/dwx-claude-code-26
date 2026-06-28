# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## The Talk (what this repo is)

This repo is **a conference talk** — a Slidev presentation, not a generic template.

- **Title**: *Codex in Action — Building a Vue PWA Without Typing a Single Line*
- **Event**: DWX 2026 (Developer Week), by **Alexander Opalic**
- **Speaker site / blog**: [alexop.dev](https://alexop.dev) · [@alexanderopalic](https://twitter.com/alexanderopalic)
- **Talk hub (slides, links, demo repo)**: [alexop.dev/talks/dwx-2026](https://alexop.dev/talks/dwx-2026)
- **The deck itself**: `starter/slides.md` — this is the file you edit to change the talk.

**The pitch.** AI coding tools went from chat boxes to development partners. The talk
teaches a battle-tested workflow for shipping a Vue PWA with Codex — context,
feedback loops, and the newer primitives (`loop`, `goal`, `workflow`) wired into a
"software factory" that ships AFK (away-from-keyboard).

**Shape of the deck** (~53 slides):
- **Act I — The Basics**: what an agent actually is (a loop + tools + your codebase as its UX)
- **Act II — Set Up Your Vue Project**: the three buckets — Context, Feedback, Discoverability
- **Act III — Stop Writing Code By Hand**: loop engineering, the software factory, the AFK plugin, MCP
- **Proof**: a Workout Tracker PWA (Vue 3 + Vite + Pinia + `vite-plugin-pwa`), built zero lines typed

**Authoring notes.**
- Speaker notes live in `<!-- ... -->` blocks after each slide; most end with a `TRANSITION:` line.
- Brand pink is `#ff6bed`; reuse the existing components (`Card`, `BucketCard`, `PartSlide`,
  `PyramidOutline`, `RoughSvg`/`RoughRect`/`RoughText`/`RoughArrow`, `FolderTree`) rather than raw HTML.
- Claims and deep-dives reference Alex's own posts on alexop.dev — keep references accurate to real posts.

## Project Overview

The talk is delivered from a **pnpm workspace monorepo** containing the full Slidev stack:
- **@alexop/slidev-theme-brand**: Custom dark theme with pink accent (#ff6bed), Geist Sans and Geist Mono fonts
- **@alexop/slidev-addon-utils**: Reusable components (Callout, About, Card, BucketCard, PartSlide, …) and layouts (TwoCols)
- **starter** (package name: **`slidev-starter`**): the presentation itself — `slides.md` is the talk

## Common Commands

```bash
# Install dependencies (run from root)
pnpm install

# Development
pnpm dev                                # Start the talk dev server (http://localhost:3030)
pnpm --filter slidev-starter dev        # Same as above (package is named `slidev-starter`)
pnpm --filter slidev-theme-brand dev    # Dev mode for theme package
pnpm --filter slidev-addon-utils dev    # Dev mode for addon package

# Building
pnpm build                              # Build the talk (static site)
pnpm --filter slidev-starter build

# Export
pnpm export                             # Export the talk to PDF (default)
pnpm --filter slidev-starter export:pdf # Export as PDF
pnpm --filter slidev-starter export:png # Export as PNG sequence
```

> Note: the dev server reads interactive keyboard shortcuts from stdin, so when launched
> in a non-interactive/background shell it exits on EOF. Keep stdin open (e.g.
> `sleep 100000 | pnpm dev`) if you need it to stay up for screenshots/QA.

## Architecture

### Workspace Structure
The monorepo uses pnpm workspaces defined in `pnpm-workspace.yaml`:
- `packages/*` - Contains theme and addon packages
- `starter` - Presentation template with `workspace:*` dependencies

### Theme Package (@alexop/slidev-theme-brand)
- **Entry**: `index.ts` exports theme config with `colorSchema: 'dark'`
- **Layouts**: Cover.vue, Section.vue, default.vue (in `layouts/`)
- **Styling**: `styles/index.ts` imports Geist fonts and theme styles
- **UnoCSS**: `setup/unocss.ts` configures fonts (Geist Sans, Geist Mono)
- **Slidev defaults** in package.json: 16/9 aspect ratio, slide-left transition, dark color scheme

### Addon Package (@alexop/slidev-addon-utils)
- **Entry**: `index.ts` exports empty config
- **Components**: Callout.vue with info/warning/error types, About.vue for personal info (in `components/`)
- **Layouts**: TwoCols.vue for side-by-side content (in `layouts/`)
- **UnoCSS**: `setup/unocss.ts` with minimal config

### The Presentation (`starter/`, package `slidev-starter`)
- Uses both packages via workspace protocol: `"@alexop/slidev-theme-brand": "workspace:*"`
- **`slides.md` is the DWX 2026 talk** (see "The Talk" above) — theme + addon components in real use
- Standard Slidev project structure with `public/` for assets (demo recordings/screenshots go here)

## Key Integration Points

1. **Theme/Addon Registration**: Slidev auto-discovers packages when:
   - Theme: `slidev.colorSchema` in package.json + `index.ts` export
   - Addon: Valid slidev addon structure with components/layouts

2. **UnoCSS Configuration**: Both packages have `setup/unocss.ts` which Slidev merges with the presentation's config

3. **Workspace Dependencies**: Starter references packages via `workspace:*` - pnpm links them automatically during install

## Development Workflow

When modifying theme/addon:
1. Make changes in respective package
2. Run `pnpm dev` from root to see changes in starter (Slidev hot-reloads)
3. Or work in isolation by running `pnpm dev` within the package directory

When creating new presentations:
- Copy `starter/` directory or use as reference
- Ensure theme/addon are in dependencies
- Configure in frontmatter: `theme: '@alexop/slidev-theme-brand'` and `addons: ['@alexop/slidev-addon-utils']`
