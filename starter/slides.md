---
theme: '@alexop/slidev-theme-brand'
addons:
  - '@alexop/slidev-addon-utils'
title: 'Building Without Typing'
transition: slide-left
mdc: true
drawings:
  persist: false
info: |
  ## Building Without Typing — How I Ship Vue, Nuxt & TypeScript Without Writing the Code

  The story of how I learned to build with AI: a markdown editor, a Nuxt blog
  starter, a workout PWA — barely typing a line. What kept breaking, and why the
  fix was to invest up front: structure, lint, tests, and memory.

  By Alexander Opalic · DWX 2026 · alexop.dev
layout: cover
---

# Building Without Typing

How I ship Vue, Nuxt & TypeScript without writing the code

<div class="mt-8 text-lg op-70">
  DWX 2026 · Alexander Opalic · <span style="color: #ff6bed">alexop.dev</span>
</div>

<!--
DWX — Developer Week. One breath, then the title.

This isn't a tooling tour. It's the story of how I actually learned to build
software with AI — what worked, what kept breaking, and the one change that
fixed it.

TRANSITION: Quick intro, then the story.
-->

---

# Follow along

<div class="flex flex-col items-center gap-6 mt-12">
  <div class="text-xl op-80">No need to take notes. No need to screenshot.</div>
  <div class="text-2xl font-bold" style="color: #ff6bed">alexop.dev/talks/dwx-2026</div>
  <div class="text-sm op-60">Slides, every link, and the demo repos are all there.</div>
</div>

<!--
Everything is online — slides, links, the demo repos. Jot down questions as we
go; there's time at the end.

TRANSITION: Who am I.
-->

---

# About me

<About />

<!--
Alexander Opalic. Vue for 7+ years. Developer at Otto Payments.
Blog at alexop.dev — these days mostly Vue and AI.

TRANSITION: Let me take you back a bit.
-->

---
layout: statement
transition: fade
---

# So I started learning to build with AI.

<!--
[pause]

Like a lot of you, I went from pasting snippets out of a chat box to something
different: handing the agent a task and letting it write the whole thing.

TRANSITION: Not the way you'd expect.
-->

---
layout: statement
transition: fade
---

# Not "autocomplete." Not "ask the chatbot."

<!--
Not autocomplete. Not "ask and copy out of a chat box."

TRANSITION: Something bigger.
-->

---
layout: statement
transition: fade-out
---

# Let the agent write whole features — and check the result.

<!--
Give it a goal, let it write the feature, and review what came back.

To learn it, I did the only thing that works: I built real projects.

TRANSITION: Here's what I built.
-->

---

# I built a lot — and barely typed

<div class="text-center text-sm op-60 -mt-2 mb-6">Three real projects, written almost entirely by the agent.</div>

<div class="grid grid-cols-3 gap-6 mt-4">

<Card glow>
<div class="text-3xl mb-2">📝</div>
<div class="text-lg font-bold mb-1" style="color: #ff6bed">Markdown editor</div>
<div class="text-sm op-80">A live editor with preview, shortcuts, and local persistence. My first "let it build the whole thing" project.</div>
</Card>

<Card glow>
<div class="text-3xl mb-2">📰</div>
<div class="text-lg font-bold mb-1" style="color: #ff6bed">Nuxt blog starter</div>
<div class="text-sm op-80">Content, routing, SEO, RSS — a Nuxt template I could actually reuse. Bigger surface, more moving parts.</div>
</Card>

<Card glow>
<div class="text-3xl mb-2">🏋️</div>
<div class="text-lg font-bold mb-1" style="color: #ff6bed">Workout tracker</div>
<div class="text-sm op-80">An offline-first Vue PWA — log sets, rest timers, exercise library. The most ambitious of the three.</div>
</Card>

</div>

<div v-click class="text-center text-lg mt-8 op-80">
Each one bigger than the last. Each one mostly <strong style="color: #ff6bed">not typed by me.</strong>
</div>

<!--
Three projects, in order. A markdown editor — small, my first real "let it build
the whole thing." A Nuxt blog starter — bigger, more surface: content, routing,
SEO. And a workout tracker PWA — offline-first Vue, the most ambitious.

CLICK — Each one bigger than the last, and each one mostly written by the agent,
not by me. It felt like magic.

TRANSITION: For about a week. Then two problems showed up — every single time.
-->

---
layout: statement
transition: fade
---

# It worked — until it didn't.

<!--
[pause]

And it genuinely worked — at first.

TRANSITION: Then a pattern emerged.
-->

---
layout: statement
transition: fade-out
---

# The same two problems. Every project.

<!--
The more I built, the more the same two problems kept showing up. Not random
bugs — the same two, every single time.

TRANSITION: Problem one.
-->

---
layout: statement
transition: fade
---

<div class="text-sm op-50 mb-4 tracking-widest uppercase">Problem 1</div>

# The code didn't look like mine.

<div v-click class="text-xl op-70 mt-8">
600-line components. My conventions, ignored. <code>any</code> everywhere.
</div>

<!--
Problem one: it ran, but it wasn't code I'd have written. One giant component.
My conventions ignored. `any` wherever the types got annoying.

CLICK — It worked. I just didn't want to own it. And "works but I hate it"
becomes real the moment you have to change it.

TRANSITION: Which is problem two.
-->

---
layout: statement
transition: fade-out
---

<div class="text-sm op-50 mb-4 tracking-widest uppercase">Problem 2</div>

# I was scared to change anything.

<div v-click class="text-xl op-70 mt-8">
No tests. No structure. No way to know what I'd just broken.
</div>

<!--
Problem two, and this one hurt. Every change, I held my breath — did that break
the timer? Is offline mode still fine?

CLICK — No tests, no structure, no way to know. So I clicked through the whole
app by hand after every change. The agent was fast; I was the bottleneck,
because I couldn't trust any of it.

TRANSITION: That's when it clicked.
-->

---
layout: statement
transition: fade
---

# So I flipped the order.

<!--
[pause]

The instinct is to keep correcting the agent's output, prompt by prompt. That's
a treadmill. So I flipped it.

TRANSITION: Step one.
-->

---
layout: statement
transition: fade
---

# Stop fixing the output.

<!--
Stop correcting the agent turn by turn.

TRANSITION: And instead —
-->

---
layout: statement
transition: fade-out
---

# Spend the time <em>up front</em> — make the project right first.

<!--
Spend the time up front instead. Before asking for a single feature, I made the
project itself the kind of place where the agent does the right thing by
default — and where I can instantly tell if it didn't.

Same insight a senior dev has about any codebase: a good codebase makes good
changes easy and bad changes loud.

TRANSITION: Concretely, that's four things.
-->

---

# What "getting it right up front" means

<div class="text-center text-sm op-60 -mt-2 mb-4">Four investments that fixed both problems at once.</div>

<div class="grid grid-cols-2 gap-5 mt-4">

<Card glow>
<div class="text-lg font-bold mb-1" style="color: #ff6bed">① Structure</div>
<div class="text-sm op-80">A codebase the agent can navigate — one folder per feature, so changes stay local.</div>
</Card>

<Card glow>
<div class="text-lg font-bold mb-1" style="color: #ff6bed">② Lint rules</div>
<div class="text-sm op-80">ESLint + Oxlint that encode <em>my</em> conventions — caps on size, no <code>any</code>, no duplication.</div>
</Card>

<Card glow>
<div class="text-lg font-bold mb-1" style="color: #ff6bed">③ Tests</div>
<div class="text-sm op-80">Fast, real feedback. The agent breaks something → it goes red → it fixes itself.</div>
</Card>

<Card glow>
<div class="text-lg font-bold mb-1" style="color: #ff6bed">④ Memory</div>
<div class="text-sm op-80">Write down the rules, decisions, and gotchas once — so the agent stops repeating mistakes.</div>
</Card>

</div>

<div v-click class="text-center text-lg mt-6 op-80">
Structure &amp; memory fix <strong>problem 1</strong>. Lint &amp; tests fix <strong style="color: #ff6bed">problem 2</strong>.
</div>

<!--
Four investments. Structure — a codebase the agent can find its way around.
Lint rules — my conventions, enforced, not hoped for. Tests — fast feedback so
a break is obvious. Memory — write the rules down once so they stick.

CLICK — And notice the symmetry. Structure and memory fix "the code didn't look
how I wanted." Lint and tests fix "I was scared to change anything." Both
problems, gone.

None of this is AI-specific, by the way. It's just good engineering — it now
pays off twice.

We'll take these one at a time, step by step, for Vue, Nuxt and TypeScript — and
the same patterns apply to any codebase.

TRANSITION: Start with structure.
-->

---
transition: fade
---

<PartSlide
  part="1"
  title="Structure"
  subtitle="One folder = one feature"
/>

<!--
The folder layout is the API the agent uses to read your code. Most Vue and Nuxt
apps start flat — and flat is exactly where the agent gets lost and writes the
600-line component.
-->

---

# Convert flat → feature-sliced

<div class="text-center text-sm op-60 mb-4">Same files. Same code. Different addressing.</div>

````md magic-move {lines: true}
```text
📁 src/
├── 📁 components/
│   ├── 🏋️ WorkoutActiveMode.vue
│   ├── 🏋️ WorkoutHeader.vue
│   ├── ⏱️ TimerDisplay.vue
│   ├── 💪 ExerciseList.vue
│   └── ⚙️ SettingsForm.vue
├── 📁 composables/
│   ├── 🏋️ useWorkoutMode.ts
│   ├── ⏱️ useRestTimer.ts
│   ├── 💪 useExercises.ts
│   └── ⚙️ useSettings.ts
└── 📁 stores/
    ├── 🏋️ workout.ts
    ├── ⏱️ timers.ts
    └── ⚙️ settings.ts
```

```text
📁 src/features/
├── 📁 workout/
│   ├── 📁 components/
│   │   ├── 🏋️ WorkoutActiveMode.vue
│   │   └── 🏋️ WorkoutHeader.vue
│   ├── 📁 composables/
│   │   └── 🏋️ useWorkoutMode.ts
│   └── 🏋️ store.ts
├── 📁 timers/
│   ├── 📁 components/
│   │   └── ⏱️ TimerDisplay.vue
│   ├── 📁 composables/
│   │   └── ⏱️ useRestTimer.ts
│   └── ⏱️ store.ts
├── 📁 exercises/
│   └── 📁 components/
│       └── 💪 ExerciseList.vue
└── 📁 settings/
    ├── 📁 components/
    │   └── ⚙️ SettingsForm.vue
    └── ⚙️ store.ts
```
````

<!--
[click] State 1 — a typical Vue app. Grouped by what files ARE: components,
composables, stores. A change to "workout" touches three folders. The agent
greps the whole tree and pulls in noise.

[click] State 2 — same files, regrouped by what they DO. workout/ is one folder.

Prompt: "add a streak counter to the active workout." Flat — the agent searches
across folders, most of what it reads is irrelevant. Feature-sliced — it lists
ONE folder, all of it relevant. The change stays local, so I stop being scared
of it.

Plus three import rules: features don't import each other, only the app layer
sees everything — and a lint rule enforces it. Which is a perfect segue.

TRANSITION: Lint rules.
-->

---
transition: fade
---

<PartSlide
  part="2"
  title="Lint rules"
  subtitle="Encode your conventions — don't hope for them"
/>

<!--
Problem one was "the code didn't follow my conventions." You don't fix that by
repeating yourself in every prompt. You make the conventions executable.
-->

---

# Make your conventions executable

<div class="text-sm op-60 mb-4">Every rule you encode is a mistake the agent can't make twice.</div>

```js
// eslint.config.js — caps and bans that stop the patterns I hate
export default [
  {
    rules: {
      // No more 600-line components
      'vue/max-template-depth': ['error', { maxDepth: 4 }],
      'max-lines': ['error', { max: 200 }],
      // No `any`, no silent escapes
      '@typescript-eslint/no-explicit-any': 'error',
      // Features can't import each other (structure, enforced)
      'import/no-restricted-paths': ['error', { /* zones */ }],
    },
  },
]
```

<div class="grid grid-cols-2 gap-5 mt-6">

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">Oxlint</strong> for speed (~50× faster), <strong style="color: #ff6bed">ESLint</strong> for the rich Vue/TS rules.</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-sm">The agent runs <code>lint:fix</code>, reads the error, and fixes itself — <strong style="color: #ff6bed">no nagging from me.</strong></div>
</Card>

</div>

<!--
The fix for "it ignored my conventions" is to stop describing them and start
enforcing them. Caps on component size and template depth — no more 600-line
component. Ban `any`. And the import rule that enforces the structure from the
last section.

Oxlint for raw speed, ESLint for the rich Vue and TypeScript rules. The key
move: the agent runs lint itself, reads the violation, and corrects it — I'm not
in the loop repeating "small components, please" for the hundredth time.

A rule encoded once is a mistake the agent can't make again.

TRANSITION: Lint catches the shape. Tests catch the behavior.
-->

---
transition: fade
---

<PartSlide
  part="3"
  title="Tests"
  subtitle="Fast feedback the agent can chase to green"
/>

<!--
Problem two was fear: I couldn't change anything without breaking something
invisibly. Tests are the cure. A test suite is permission to let the agent move
fast — because if it breaks something, you both find out instantly.
-->

---

# Backpressure, layer by layer

<div class="grid grid-cols-2 gap-5 mt-6">

<Card glow>
<div class="text-xs op-60 mb-1">Layer 1 · Types</div>
<div class="text-sm op-80">Strict <code>tsconfig</code> + <strong>Zod</strong> at every untyped boundary. The agent stops reaching for <code>any</code>.</div>
</Card>

<Card glow>
<div class="text-xs op-60 mb-1">Layer 2 · Unit tests</div>
<div class="text-sm op-80"><strong>Vitest</strong>, watch mode. Pure functions, composables, stores. Green or red in milliseconds.</div>
</Card>

<Card glow>
<div class="text-xs op-60 mb-1">Layer 3 · Component tests</div>
<div class="text-sm op-80"><strong>Vitest browser mode</strong> — real Chromium. Hover, focus, layout — no jsdom fakes.</div>
</Card>

<Card glow>
<div class="text-xs op-60 mb-1">Layer 4 · The agent as a user</div>
<div class="text-sm op-80"><strong>agent-browser</strong> — the agent drives the real app and checks it actually <em>works</em>.</div>
</Card>

</div>

<div v-click class="mt-6">

```yaml
# lefthook.yml — the commit-time GATE. Bad code never reaches the branch.
pre-commit:
  parallel: true
  jobs:
    - run: pnpm oxlint
    - run: pnpm vue-tsc --build
    - run: pnpm vitest related --run {staged_files}
```

</div>

<!--
Four layers, cheapest first. Types catch the bug before it runs. Unit tests give
millisecond feedback on logic. Component tests in real Chromium mean "passes"
means "works in a browser." And the agent driving the real app catches the
stuff no unit test can — the timer that drifts, the modal that won't open.

CLICK — Those are all signals. Lefthook is the gate: lint, types, and the tests
for the files you touched, all on every commit, in parallel. The agent can't
commit code that breaks the suite.

This is what killed my fear. I don't click through the app anymore — red tells me.

TRANSITION: Last piece — memory.
-->

---

# The agent as a user

<div class="text-center text-sm op-60 mb-6">Types are green. Lint is green. Tests are green. But did it actually <em>work</em>?</div>

```bash
npm i -g agent-browser
agent-browser install              # downloads Chromium

agent-browser open localhost:5173
agent-browser snapshot -i          # accessibility tree with @refs
agent-browser click @e2            # click by ref
agent-browser fill @e3 "hello"     # type into an input
agent-browser screenshot --annotate
agent-browser console              # read page console errors
```

<div v-click class="text-center text-lg mt-6">
Run the app locally <strong style="color: #ff6bed">+</strong> drive a real browser <strong style="color: #ff6bed">=</strong> the agent verifies its own change like a user.
</div>

<!--
This is the layer that caught the bugs I used to find by hand. Static checks
can't tell you the modal opened or the rest timer is accurate. agent-browser is
a browser CLI shaped for agents: one install, then the agent clicks, fills,
screenshots, and reads console errors — the same things a human QA notices in
the first thirty seconds.

CLICK — Run the app + drive a real browser, and the agent reviews its own work
the way I used to. That's the click-through-by-hand step, automated.

TRANSITION: Structure, lint, tests — solved. The last problem is forgetting.
-->

---
transition: fade
---

<PartSlide
  part="4"
  title="Memory"
  subtitle="Stop the agent repeating the same mistakes"
/>

<!--
The last frustration: the agent makes a mistake, I correct it, and next session
it makes the exact same mistake again — because it remembers nothing. The fix is
to give it durable, written memory.
-->

---

# AGENTS.md: dump vs. doorway

<div class="grid grid-cols-2 gap-6 mt-2">

<Card variant="muted" dashed>

<div class="text-xs font-bold mb-2" style="color: #ef4444">BAD · ~2000 lines</div>

```md
# AGENTS.md

## Project Overview
...50 lines...

## Code Style
...200 lines of formatting rules...

## Architecture Decisions
...150 lines of history...

## Gotchas
...300 lines of edge cases...
```

<div class="mt-2 text-xs" style="color: #ef4444">
Half the context gone before any work starts.
</div>

</Card>

<Card glow>

<div class="text-xs font-bold mb-2" style="color: #ff6bed">GOOD · ~50 lines</div>

```md
# AGENTS.md

Run `pnpm lint:fix && pnpm typecheck` after changes.

## Stack
Vue 3, Nuxt, Vite, Pinia

## Structure
- `src/features/` — one folder per feature

## Further reading

**IMPORTANT:** read the relevant doc below
before starting any task.

- `docs/testing-strategy.md`
- `docs/conventions.md`
```

<div class="mt-2 text-xs" style="color: #ff6bed">
Loads docs only when relevant.
</div>

</Card>

</div>

<div v-click class="absolute bottom-4 left-0 right-0 text-center text-lg">
  Progressive disclosure. <strong style="color: #ff6bed">The right context at the right time.</strong>
</div>

<!--
AGENTS.md is the front door — the first memory the agent reads. The day-one
instinct is to dump everything: 2000 lines, half the context window gone before
work starts, and the model degrades on noise.

The version that works: one line for tooling — the agent runs it and self-corrects.
A short stack and structure. Then "Further reading" with an IMPORTANT instruction
so docs load only when the task needs them.

CLICK — Progressive disclosure: the right context at the right time, not all of
it all the time.

TRANSITION: AGENTS.md is the front door. The deeper memory lives in a vault.
-->

---

# A `brain/` vault — durable memory

<div class="grid grid-cols-2 gap-8 mt-6 items-center">

<div class="space-y-3">

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">principles/</strong> — rules &amp; gotchas the agent reads <em>before</em> acting</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">decisions/</strong> — the ADRs worth keeping</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">codebase/</strong> — as-is maps, so it doesn't re-derive how an area works</div>
</Card>

<Card glow size="sm">
<div class="text-sm">Checked into the repo. A <code>SessionStart</code> hook loads the map; the agent <strong>reads before acting, writes back as it learns.</strong></div>
</Card>

</div>

<div>

```text
📁 brain/
├── 📄 context.md
├── 📁 principles/
│   └── timers-use-timestamps.md
├── 📁 decisions/
├── 📁 codebase/
└── 📁 plans/
```

<div class="text-xs op-60 mt-4 text-center">Plain markdown. Checked in. Shared by the whole team.</div>

</div>

</div>

<!--
The brain/ vault is the deeper memory: a plain markdown folder, checked into the
repo. principles — the lessons, read before every task. decisions — ADRs.
codebase — as-is maps of how an area actually works. plans — the agreed plan.

The key behavior: a SessionStart hook loads the index every session, and the
agent reads it before acting and writes lessons back as it learns. So when the
rest timer drifts, I don't just patch it — I add one principle, "timers use
timestamps, not intervals," and the next timer is correct by default.

And because it's in the repo, the whole team's agent boots from the same memory.

TRANSITION: AGENTS.md and brain/ are facts and lessons. The last kind of memory is how-to.
-->

---

# Skills: memory for *how to do things*

<div class="text-center text-sm op-60 -mt-2 mb-4">AGENTS.md holds facts. <code>brain/</code> holds lessons. Skills hold repeatable procedures.</div>

<div class="grid grid-cols-2 gap-8 mt-2 items-center">

<div>

```text
📁 .claude/skills/
└── 📁 add-feature/
    ├── 📄 SKILL.md      ← name + when-to-use
    ├── 📄 checklist.md  ← loaded on match
    └── 🔧 scaffold.ts   ← run only if needed
```

<div class="text-xs op-60 mt-4 text-center">Same progressive disclosure — index now, steps on demand.</div>

</div>

<div class="space-y-3">

<Card variant="muted" size="sm">
<div class="text-sm">The agent sees only a <strong style="color: #ff6bed">~100-token index</strong> — name + description.</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-sm">Task matches → the <strong style="color: #ff6bed">full steps load.</strong> Fifty skills, no upfront cost.</div>
</Card>

<Card glow size="sm">
<div class="text-sm">My repeatable workflows — "add a feature", "a Pinia store the way I write them" — encoded once, replayed every time.</div>
</Card>

</div>

</div>

<!--
AGENTS.md and brain/ are knowledge — what's true and what I've learned. Skills
are the other half: how to DO a recurring job, step by step.

A skill is just a folder with a SKILL.md — a name and a "when to use this," plus
the steps in the body. Same progressive-disclosure trick as AGENTS.md: the agent
only carries a ~100-token index of every skill, and pulls the full instructions
in when a task actually matches. That's how you give it fifty capabilities
without paying for fifty on every turn.

So the workflows I'd otherwise re-explain — "add a feature end to end," "write a
store the way I write them" — get encoded once and replayed exactly.

TRANSITION: Step back — that's actually four different kinds of memory.
-->

---
clicks: 1
---

# Memory isn't one thing — it's four

<div class="text-center text-sm op-60 -mt-2 mb-4">The CoALA framework (Princeton). In Claude Code, every type is a file or a command.</div>

<div class="grid grid-cols-2 gap-5 mt-4">

<Card glow size="sm">
<div class="text-xs op-60 mb-1">Working · the context window</div>
<div class="text-sm op-80"><strong style="color: #ff6bed">/context · /clear · /compact.</strong> Keep it lean — that's progressive disclosure.</div>
</Card>

<Card glow size="sm">
<div class="text-xs op-60 mb-1">Semantic · stable facts</div>
<div class="text-sm op-80"><strong style="color: #ff6bed">AGENTS.md + docs/.</strong> Loaded every session.</div>
</Card>

<Card glow size="sm">
<div class="text-xs op-60 mb-1">Procedural · how-to</div>
<div class="text-sm op-80"><strong style="color: #ff6bed">Skills.</strong> Repeatable workflows, loaded on match.</div>
</Card>

<Card glow size="sm">
<div class="text-xs op-60 mb-1">Episodic · lived experience</div>
<div class="text-sm op-80"><strong style="color: #ff6bed">brain/ + auto memory.</strong> Lessons distilled, written back.</div>
</Card>

</div>

<div v-click class="text-center text-lg mt-6 op-80">
A chatbot has working memory. A coding agent needs <strong style="color: #ff6bed">all four.</strong>
</div>

<!--
Here's the frame that ties the whole section together. Researchers at Princeton
split agent memory into four types — CoALA — and the nice thing about Claude
Code is every one maps to a file or a command you can point at.

Working memory is the context window — /context, /clear, /compact, and the whole
"don't bloat it" discipline. Semantic is stable facts: AGENTS.md plus docs.
Procedural is how-to: skills. Episodic is lived experience: the brain/ vault, and
Claude Code's own auto memory that distills lessons and writes them back.

CLICK — A chatbot only has the first one, working memory. The thing that makes a
coding agent feel like it learns is the other three. We just built all four.

TRANSITION: That closes the loop. Let me bring it back.
-->

---
clicks: 4
transition: fade-out
---

# The whole talk, in one screen

<v-clicks>

- **Structure** — one folder per feature, so changes stay local *(fixes "wrong-looking code")*
- **Lint rules** — your conventions, enforced not hoped for *(fixes "wrong-looking code")*
- **Tests** — fast feedback + the agent as a user *(fixes "scared to change anything")*
- **Memory** — AGENTS.md + a `brain/` vault, so mistakes don't repeat

</v-clicks>

<div v-click class="text-center text-lg mt-10 op-80">
Invest up front, and the agent writes code you'd <strong style="color: #ff6bed">actually own — and trust.</strong>
</div>

<!--
CLICK structure — changes stay local.
CLICK lint — conventions enforced.
CLICK tests — fast feedback, plus the agent verifying like a user.
CLICK memory — written down once, so it sticks.

CLICK — The two problems that stalled me both came down to the same fix: invest
up front. Do that, and the agent ships code you actually want to own, and you
stop being scared to change it.

TRANSITION: One last point — this isn't just a Vue thing.
-->

---

---
layout: statement
transition: fade
---

# Same patterns. Any stack.

<div class="text-xl op-70 mt-8">
React, a Node backend, Go — the agent needs the same four things everywhere.
</div>

<!--
I used Vue and Nuxt because that's my world, but nothing here is Vue-specific.
Structure, lint, tests, memory — an agent needs the same four things in any
codebase. And none of it is new: it's the engineering seniors have fought for
for twenty years. What's good for a human team is good for an agent — it just
pays off twice now.

TRANSITION: So here's the real point.
-->

---
layout: statement
transition: fade
---

# This was never about typing less.

<!--
[pause]

The title says "without typing." That's the hook. But typing was never the
bottleneck.

TRANSITION: This is.
-->

---
layout: statement
transition: fade-out
---

# It's about building a project an agent can build in.

<!--
Get the project right — structure, lint, tests, memory — and you stop writing
code by hand. Not because you type less, but because the agent can finally do
the work, and you can finally trust it.

TRANSITION: Thank you.
-->

---
layout: end
transition: fade
---

# Thank You!

<div class="flex flex-col items-center gap-4 mt-10">
  <div class="text-xl"><span style="color: #ff6bed">alexop.dev/talks/dwx-2026</span></div>
  <div class="text-base op-70">alexop.dev · @alexanderopalic</div>
  <div class="text-sm op-50 mt-2">Slides, the write-ups, and the demo repos — all there.</div>
</div>

<!--
[breathe] [look up]

Thank you! Everything's at that link — slides, the deep-dives, the demo repos.
Questions now, or come find me after. I want to hear what your AGENTS.md looks
like.
-->
