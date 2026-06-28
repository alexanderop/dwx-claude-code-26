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

  Two threads, one hour: the general Claude Code workflow that actually works,
  and how to shape a Vue codebase so the agent does the typing for you.

  A markdown editor, a Nuxt blog starter, a workout PWA — barely typing a line.
  What kept breaking, and why the fix was to invest up front: structure, lint,
  tests, and memory. Plus the software factory that ships AFK.

  By Alexander Opalic · DWX 2026 · alexop.dev
layout: image
image: /dwx-2026-poster.png
backgroundSize: contain
---

<!--
Opening visual — DWX 2026, Mannheim. Let it breathe for a beat, then move on.

TRANSITION: Now the title.
-->

---
layout: cover
---

# Claude Code in Action: Building a Vue PWA Without Typing a Single Line

How I ship Vue, Nuxt & TypeScript without writing the code

<div class="mt-8 text-lg op-70">
  DWX 2026 · Alexander Opalic · <span style="color: #ff6bed">alexop.dev</span>
</div>

<!--
DWX — Developer Week. One breath, then the title.

This isn't a tooling tour. It's two threads braided together: the general
Claude Code workflow that works in any codebase, and the specific moves that
make a Vue project one the agent can build in. One hour, one story.

TRANSITION: Quick intro, then where we are in 2026.
-->

---

# About me

<About />

<div class="flex flex-col items-center gap-1 mt-6">
  <div class="text-sm op-70">No notes needed — slides, every link, and the demo repos live here:</div>
  <div class="text-xl font-bold" style="color: #ff6bed">alexop.dev/talks/dwx-2026</div>
</div>

<!--
Alexander Opalic. Vue for 8+ years. Developer at Otto Payments. Blog at
alexop.dev — these days mostly Vue and AI.

And everything's online — slides, links, demo repos — all at that link. No need
to take notes or screenshot. We've got an hour: ~45 min of talk, the rest is
yours for questions.

TRANSITION: Now — here is the world we're shipping into.
-->

---
layout: center
class: 'text-center'
---

# Before we start — who's in the room?

<div class="text-lg op-70 mt-2 mb-8">Hands up. I'm reading the room.</div>

<TalkCardGrid
  :columns="2"
  compact
  max-width="max-w-3xl"
  :cards="[
    { title: 'Claude Code', glow: true },
    { title: 'Cursor', glow: true },
    { title: 'GitHub Copilot', glow: true },
    { title: 'Codex / other', glow: true },
  ]"
/>

<div class="text-sm op-60 mt-8">No wrong answer. I just want to know who I'm talking to.</div>

<!--
[step toward the audience, hand already up]

Before a single slide of content — I want to see the room.

Hands up if you've shipped REAL code with an AI agent, not just autocomplete.
[scan] Keep your hand up if it was Claude Code... now Cursor... now Copilot...
Codex or something else.

Hands DOWN. Now the opposite: who hasn't touched any of these yet? [scan]
Perfect — you're exactly who the first ten minutes are for.

React to whatever you see: "okay, mostly Copilot — good, everything here is an
open format, it all works in Copilot too."

TRANSITION: Wherever you are on that — here's the map everyone's climbing.
-->

---
layout: image
image: /five-levels.png
backgroundSize: contain
---

<!--
Dan Shapiro framed this beautifully. Six levels, like driving automation.

L0 spicy autocomplete — a smarter Stack Overflow. L1 coding intern — boilerplate,
you review every line. L2 junior dev — pair programmer. L3 developer — AI writes
most, you're the verification bottleneck. L4 senior dev — runs unattended. L5
software factory — you manage goals, AI defines, ships, fixes.

[walk the levels with your hand as you call them] One hand, your honest level —
where you actually are this week, not where you wish you were. L0? [count] L1?
L2? L3? L4? L5? [scan, smile]

Name the median out loud: "most hands at L1 and L2 — so by the end of this hour
I want to move you one level to the right. That's the whole goal."

TRANSITION: And here's how fast that ceiling is moving.
-->

---

# Two weeks ago: Bun got rewritten in Rust

<TalkFramedImage src="/bun-rust-pr.png" max-height="20rem" />

<!--
Exhibit A for why this talk matters.

Bun — one of the most-hyped JS runtimes — rewritten from Zig to Rust.
1M lines. 10 days. By an agent.

Almost entirely Claude. Near-zero human review. 13k unsafe blocks.
The Rust and Zig communities melted down. The reviewers were Claude.
Claude even flagged a follow-up PR as AI slop.

Triumph or disaster? I don't know yet.
What I know: this is the world we ship into. Major OSS rewritten in two weeks
by a machine. The pace is real. Not slowing down.

TRANSITION: And that pace? It's relentless. You feel it every morning.
-->

---
layout: center
class: 'text-center'
---

<TalkFramedImage src="/claude-update-cat.png" max-height="22rem" :shadow="false" />

<!--
[let it land, get the laugh]

This is the lived experience. You wake up, pour your coffee — there's another
Claude update. New model, new primitive, new way to do the thing you just
learned yesterday.

Tinfoil hat on, half-paranoid, trying to keep up.

I'm not going to teach you every feature — half of them will change by the time
you get home. I'm going to teach you the WORKFLOW underneath, the part that
doesn't change.

TRANSITION: So here is the line everyone keeps repeating.
-->

---
layout: statement
transition: fade-out
---

# "You don't have to write code anymore."

<v-click>

# That's half true.

</v-click>

<v-click>

# Only if your project is built for AI — and you know what you're doing.

</v-click>

<!--
[wait]

Everyone keeps saying this line.

CLICK — Half true.

CLICK — It only works if your codebase lets the agent work.

In some of my repos AI 10x'd me. In others it produced complete garbage.
Same person. Same agent. Same model. Different codebases.

TRANSITION: So the question is...
-->

---
transition: fade-out
---

<TalkFramedImage src="/why-ai-succeeds.png" contain />

<!--
[hold the silence]

This is the question.
Why does the same agent succeed in one repo and fail in another?

The rest of the talk is the answer — in two threads. First, what an agent
actually is, so the fixes make sense. Then the concrete moves in a Vue codebase.

TRANSITION: Let's start by stripping the magic. What IS an agent?
-->

---
transition: fade
---

<PartSlide
  title="What an Agent Actually Is"
  subtitle="A loop, not a magic box — a new engineer joining your team"
/>

<!--
[scan room]

Thread one: the general Claude Code mental model. It applies to any stack.
Most devs treat agents as magic. Magic is the wrong mental model — and it's
why people can't predict when the agent will fail.
-->

---

<TalkFramedImage src="/how-an-ai-agent-works.png" alt="How an AI agent works" :rounded="false" :shadow="false" />

<!--
That is the whole picture.
Read context. Pick a tool. Run it. Read the result. Repeat.

Bounded by three things: the context window, the tools it has, and its
ability to verify its own work.

The analogy that unlocks everything: a new engineer. You wouldn't throw a new
hire into your worst legacy module and expect a feature in a week. Same with
agents. The codebase is their onboarding.

TRANSITION: Let me strip the magic further — what a tool is, and what the model actually gets.
-->

---
layout: two-cols-header
---

# The model only sees the description

::left::

<div class="pr-4">

<div class="text-xs op-60 mb-2">What you write</div>

```ts
['read', {
  description: 'Read file with line numbers',
  schema: { path: 'string' },
  execute: read,  // ← never sent
}]
```

</div>

::right::

<div class="pl-4">

<div class="text-xs op-60 mb-2">What the model gets · <code>makeSchema()</code></div>

```json
{
  "name": "read",
  "description": "Read file with line numbers",
  "input_schema": {
    "type": "object",
    "properties": { "path": { "type": "string" } },
    "required": ["path"]
  }
}
```

</div>

<!--
This is the part that demystifies everything.

LEFT — what you write. A tool with an execute function.
RIGHT — what the model actually receives. Name, description, and a JSON schema
for the arguments. Notice what's missing: execute. The function body never
leaves your machine. The model cannot run read(). It cannot even see it.

So how does it "use" a tool? It reads the description and emits a request —
"call read with path equals src/App.vue." Your loop runs the real function and
feeds the result back.

Which means the description IS the prompt. A vague description is a tool the
model misuses. Tool descriptions are engineering, not docs.

TRANSITION: And the loop that runs those tools is just recursion.
-->

---

# The loop is just recursion

```ts {2-3|5-8|11|14-18|all}
async function agentLoop(messages, systemPrompt, tools = TOOLS) {
  const response = await callApi(messages, systemPrompt, tools)
  const toolResults = await processToolCalls(response.content)

  const newMessages = [
    ...messages,
    { role: 'assistant', content: response.content },
  ]

  // No tool calls → the agent is done
  if (toolResults.length === 0) return newMessages

  // Tool calls → loop with results as the next user turn
  return agentLoop(
    [...newMessages, { role: 'user', content: toolResults }],
    systemPrompt,
    tools,
  )
}
```

<!--
And the loop is just recursion. Walk it one highlight at a time:

CLICK — call the API, run every tool the model asked for.
CLICK — grow the conversation: append the assistant's reply.
CLICK — no tool calls? The agent is done. Return.
CLICK — otherwise recurse, with the tool results as the next user turn.
CLICK — that's all of it, lit up at once.

That is the entire agent architecture. Everyone talks about agents like a
mystery. They're not.

(One level up there's a second loop — the REPL that appends each user turn and
keeps the growing `messages` array. That array IS the agent's memory: no
database, no session store, just a list that starts empty.)

TRANSITION: So how big is this whole thing?
-->

---
transition: fade-out
---

<TalkFramedImage src="/nanocode-repo.png" contain />

<!--
[pause]

That is nanocode. I built it to understand Claude Code from the inside.
~350 lines of TypeScript. A function that calls itself with the results of
the previous call.

Once you see an agent this way, the question stops being "how does the magic
work?" The question becomes: why does the same simple loop work brilliantly in
one repo and fall apart in another?

That is what the rest of this talk is about.

TRANSITION: And the answer is older than you'd think.
-->

---
layout: statement
transition: fade-out
---

# Clean code isn't nice-to-have anymore.

<v-click>

# Your codebase is the agent's UX.

</v-click>

<!--
[pause before speaking. let it land]

You don't need new patterns for AI. The patterns you already fight for in code
review — the ones the senior dev keeps insisting on — those are the patterns
that make agents work.

If you've spent years caring about architecture, testability, naming,
separation of concerns — you've been training for this moment without knowing it.

CLICK — A codebase that is hard for humans is hard for agents. Sprawl, hidden
coupling, magical state — humans hate it. Agents fail at it. Your codebase is
the agent's UX.

TRANSITION: Let me show you how I learned that — the hard way.
-->

---
layout: statement
transition: fade
---

# So I started learning to build with AI.

<!--
[pause]

Thread two starts here — the personal story, in Vue.

Like a lot of you, I went from pasting snippets out of a chat box to something
different: handing the agent a task and letting it write the whole thing.

TRANSITION: Not the way you'd expect.
-->

---

# I built a lot — and barely typed

<div class="text-center text-sm op-60 -mt-2 mb-6">Three real projects, written almost entirely by the agent.</div>

<TalkCardGrid
  class="mt-4"
  :cards="[
    { icon: '📝', title: 'Markdown editor', body: 'A live editor with preview, shortcuts, and local persistence. My first &quot;let it build the whole thing&quot; project.', glow: true },
    { icon: '📰', title: 'Nuxt blog starter', body: 'Content, routing, SEO, RSS — a Nuxt template I could actually reuse. Bigger surface, more moving parts.', glow: true },
    { icon: '🏋️', title: 'Workout tracker', body: 'An offline-first Vue PWA — log sets, rest timers, exercise library. The most ambitious of the three.', glow: true },
  ]"
/>

<div v-click class="text-center text-lg mt-8 op-80">
Each one bigger than the last. Each one mostly <strong style="color: #ff6bed">not typed by me.</strong>
</div>

<!--
Three projects, in order. A markdown editor — small, my first real "let it
build the whole thing." A Nuxt blog starter — bigger surface: content, routing,
SEO. And a workout tracker PWA — offline-first Vue, the most ambitious.

CLICK — Each one bigger than the last, and each one mostly written by the agent,
not by me. It felt like magic.

TRANSITION: Let me make the biggest one concrete.
-->

---
layout: iframe
url: https://workout-tracker-ten-pi.vercel.app/
transition: fade
---

<!--
This is the workout tracker. Offline-first Vue PWA: log workouts, track sets,
run rest timers, keep history, use it on the phone like a real app.

I want you to have the product in your head before we talk about the workflow,
because this is not "generate a todo app." The agent had to build something with
state, persistence, mobile UX, and all the little edge cases that make product
code real.

TRANSITION: And it worked — for about a week. Then two problems showed up every
single time.
-->

---
layout: statement
transition: fade
---

# It worked — until it didn't.

<v-click>

# The same two problems. Every project.

</v-click>

<!--
[pause]

And it genuinely worked — at first.

CLICK — Then a pattern emerged. The more I built, the more the same two problems
kept showing up. Not random bugs — the same two, every single time.

TRANSITION: Here they are.
-->

---
layout: statement
transition: fade-out
---

<div class="grid grid-cols-2 gap-10 max-w-5xl mx-auto mt-6 text-left">

<div v-click>
<div class="text-sm op-50 mb-3 tracking-widest uppercase">Problem 1</div>
<div class="text-3xl font-bold">The code didn't look like mine.</div>
<div class="text-lg op-70 mt-4">600-line components. My conventions, ignored. <code>any</code> everywhere.</div>
</div>

<div v-click>
<div class="text-sm op-50 mb-3 tracking-widest uppercase">Problem 2</div>
<div class="text-3xl font-bold">I was scared to change anything.</div>
<div class="text-lg op-70 mt-4">No tests. No structure. No way to know what I'd just broken.</div>
</div>

</div>

<!--
Two problems, every single project.

CLICK — Problem one: it ran, but it wasn't code I'd have written. One giant
component, my conventions ignored, `any` wherever the types got annoying. It
worked; I just didn't want to own it — and "works but I hate it" becomes real
the moment you have to change it.

CLICK — Problem two, and this one hurt. Every change I held my breath: did that
break the timer? Still offline-safe? No tests, no structure, no way to know — so
I clicked through the whole app by hand after every change. The agent was fast; I
was the bottleneck, because I couldn't trust any of it.

TRANSITION: That's when it clicked.
-->

---
layout: statement
transition: fade
---

# So I flipped the order.

<v-click>

<div class="text-xl op-70 mt-8 max-w-3xl mx-auto">When the agent slips, fix the <strong style="color: #ff6bed">factory — the project itself</strong> — not just the one PR.</div>

</v-click>

<!--
[pause]

The instinct is to keep correcting the agent's output, prompt by prompt. That's
a treadmill. So I flipped it: stop correcting turn by turn. Spend the time up
front instead — make the project itself the kind of place where the agent does
the right thing by default, and where I can instantly tell if it didn't.

CLICK — and the phrase to hold onto for the whole hour: when the agent gets it
wrong, fix the FACTORY, not the PR. The project, the rules, the structure — so
that whole class of mistake can't happen again. We'll come back to it, hard, in
the last act.

Same insight a senior dev has about any codebase: a good codebase makes good
changes easy and bad changes loud.

TRANSITION: Concretely, that's three buckets.
-->

---

<PyramidOutline :items="[
  { title: 'What an Agent Actually Is', subtitle: 'A loop, not a magic box — done' },
  { title: 'Context', subtitle: 'What the agent knows before it starts' },
  { title: 'Feedback Loops', subtitle: 'How it knows when it is wrong' },
  { title: 'Discoverability', subtitle: 'How it finds the right code' },
  { title: 'Where this is heading', subtitle: 'The software factory' }
]" />

<!--
Here's the map for the rest of the hour.

We've done the foundation — what an agent is. Now three buckets you can act on
Monday: Context, Feedback, Discoverability. Then we close on where this is
heading — the software factory.

And notice the symmetry with my two problems. Context and discoverability fix
"the code didn't look like mine." Feedback fixes "I was scared to change
anything." None of it is AI-specific — it's just good engineering that now
pays off twice.

TRANSITION: Bucket one — context.
-->

---
transition: fade
---

<PartSlide
  part="1"
  title="Context"
  subtitle="AGENTS.md is the unlock"
/>

<!--
[scan room]

Bucket one. The foundation. Context defines the structure, how we test, the
style guide — everything a new dev would also need. Once context is solid, you
can ask the agent to add oxlint, wire up vitest, scaffold the folders — it
knows the rules now.
-->

---
layout: statement
transition: fade-out
---

# Every model has a context window.

<v-click>

# And it works best when it's <em>not</em> full.

</v-click>

<!--
Two truths about agent memory. One: nothing carries between turns — every turn
the context resets, no yesterday. Two: even within a turn, the window is finite.
200k tokens at Anthropic, 1M with the extended Opus window. OpenAI, Gemini —
same shape. A budget.

CLICK — And it works BEST when it's not full. Models degrade as the window
fills. Recall drops. Reasoning slips. The agent starts confusing files. This is
the "dumb zone" HumanLayer talks about.

TRANSITION: And here's the kicker. The window is not empty when you start.
-->

---

# The window isn't empty when you start

<div class="h-full flex flex-col items-center justify-center -mt-12">

<div class="text-7xl font-bold" style="color: #ff6bed">~20k tokens</div>

<div class="mt-4 text-lg op-70">spent before you type a word</div>

<div class="mt-10 flex gap-6 text-sm op-60">
  <span>system prompt <span class="op-80">~9k</span></span>
  <span>·</span>
  <span>tool definitions <span class="op-80">~10k</span></span>
</div>

</div>

<!--
Every provider does this. System prompt — "you are a coding assistant, here
are the rules, here's how to format, here's what to refuse." ~9k at Anthropic.

Tool definitions — every tool the harness exposes (Read, Edit, Bash, Grep,
Glob, WebFetch) gets a name, schema, description. ~10k before you've done
anything. 20k gone. Your budget is what's LEFT.

And then AGENTS.md, skills, sub-agents — they all spend from the
SAME pool. That's why a 2000-line AGENTS.md isn't just noise — it's tokens that
could have held real code.

TRANSITION: Don't believe me? Claude Code shows you exactly.
-->

---

# `/context`: see your budget

<div class="text-center text-sm op-60 mb-5">Claude Code ships a slash command that shows what's eating your window.</div>

<Card variant="muted" class="max-w-4xl mx-auto">

<div class="font-mono text-xs op-50 mb-3">> /context</div>

<div class="flex h-8 rounded overflow-hidden mb-1 border border-white/10">
  <div style="width: 32.4%; background: #ff6bed"></div>
  <div style="width: 35.2%; background: #60a5fa"></div>
  <div style="width: 4.6%; background: #a78bfa"></div>
  <div style="width: 5.7%; background: #fb923c"></div>
  <div style="width: 21.7%; background: #fbbf24"></div>
  <div style="width: 0.4%; background: rgba(255,255,255,0.15)"></div>
</div>
<div class="text-center text-xs op-60 mb-5">28k of 1M tokens used. Share of the <strong>used</strong> portion.</div>

<div class="grid grid-cols-2 gap-x-8 gap-y-2 text-sm">
  <div class="flex items-center gap-3"><span class="w-3 h-3 rounded-sm" style="background: #ff6bed"></span> System prompt <span class="op-50 ml-auto">9.1k <span class="op-50">(0.9%)</span></span></div>
  <div class="flex items-center gap-3"><span class="w-3 h-3 rounded-sm" style="background: #60a5fa"></span> System tools <span class="op-50 ml-auto">9.9k <span class="op-50">(1.0%)</span></span></div>
  <div class="flex items-center gap-3"><span class="w-3 h-3 rounded-sm" style="background: #a78bfa"></span> Custom agents <span class="op-50 ml-auto">1.3k <span class="op-50">(0.1%)</span></span></div>
  <div class="flex items-center gap-3"><span class="w-3 h-3 rounded-sm" style="background: #fb923c"></span> Memory files (AGENTS.md) <span class="op-50 ml-auto">1.6k <span class="op-50">(0.2%)</span></span></div>
  <div class="flex items-center gap-3"><span class="w-3 h-3 rounded-sm" style="background: #fbbf24"></span> Skills <span class="op-50 ml-auto">6.1k <span class="op-50">(0.6%)</span></span></div>
  <div class="flex items-center gap-3"><span class="w-3 h-3 rounded-sm" style="background: rgba(255,255,255,0.15)"></span> Free space <span class="op-50 ml-auto">972k <span class="op-50">(97.2%)</span></span></div>
</div>

</Card>

<!--
Type /context in Claude Code. It draws this. Pink + blue = system prompt +
tools = ~19k. Yellow = skills. Orange = memory files (AGENTS.md). Purple =
custom sub-agents. White = free.

But notice — skills, memory, sub-agents ALL eat from the same window. That's
why "I'll just add it to AGENTS.md" stops working at scale. Each addition
spends from a shared pool.

TRANSITION: So how do you spend the budget wisely? Start with AGENTS.md.
-->

---

# AGENTS.md: dump vs. doorway

<div class="grid grid-cols-2 gap-6 mt-2">

<Card variant="muted" dashed>

<div class="text-xs font-bold mb-2" style="color: #ef4444">BAD · ~2000 lines ≈ 20% of the window, spent before any code</div>

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

<div class="text-xs font-bold mb-2" style="color: #ff6bed">GOOD · 74 lines ≈ 0.2% — the real one</div>

```md
# AGENTS.md

Run `pnpm lint && pnpm type-check` after changes.
Use `pnpm` only. Never write `else` or `as`.

## Stack
Vue 3.5, TypeScript (strict), Vite,
Dexie (IndexedDB), Vitest browser mode,
shadcn-vue, Tailwind

## Structure
One folder per feature in `src/features/`.
Features never import each other.

## Further Reading
**IMPORTANT:** before a task, read the relevant
doc. **After** a task, update the matching doc —
`docs/` is the persistent knowledge graph; the
next session only knows what's written there.

- `docs/VUE_STYLE_GUIDE.md`
- `docs/workout-block-model.md`
```

<div class="mt-2 text-xs" style="color: #ff6bed">
One line of tooling. The rest loads only when relevant.
</div>

</Card>

</div>


<!--
LEFT — the instinct everyone has on day one. Dump everything. Style rules
ESLint already enforces. Bug post-mortems. Every gotcha. 2000 lines. Half the
context window gone before any work starts. The dumb zone.

RIGHT — the version that survives. ONE LINE for tooling: "run lint:fix and
typecheck after changes." The agent runs the build, reads the error, fixes
itself. That's backpressure — you stop being the linter. Then a short stack and
structure. Then "Further reading" with the IMPORTANT instruction so docs load
only when the task needs them.

Two filters before a line goes in: can a tool enforce it? Then don't write
prose. Is it universal, or situational? Situational goes in /docs.

CLICK — The right context at the right time.

TRANSITION: AGENTS.md is the front door. And Vercel just put numbers on why that matters.
-->

---
transition: fade
---

# Docs are not skills.

<div class="text-center text-lg op-70 mb-8">
Vercel tested how agents learn <span style="color: #ff6bed">Next.js 16</span> APIs they were not trained on.
</div>

<div class="grid grid-cols-3 gap-5 max-w-5xl mx-auto">

<Card variant="muted" size="sm">
<div class="text-xs op-50 mb-2">Baseline + default skill</div>
<div class="text-5xl font-bold" style="color: #ef4444">53%</div>
<div class="text-sm op-70 mt-3">The skill existed. The agent often never opened it.</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-xs op-50 mb-2">Skill + explicit instruction</div>
<div class="text-5xl font-bold" style="color: #fbbf24">79%</div>
<div class="text-sm op-70 mt-3">Better, but fragile: wording changed the behavior.</div>
</Card>

<Card glow size="sm">
<div class="text-xs op-50 mb-2">Compressed AGENTS.md docs index</div>
<div class="text-5xl font-bold" style="color: #ff6bed">100%</div>
<div class="text-sm op-70 mt-3">No trigger decision. Always available. Clear retrieval map.</div>
</Card>

</div>

<div v-click class="text-center text-xl mt-10 max-w-4xl mx-auto">
Put <strong style="color: #ff6bed">framework docs indexes</strong> in AGENTS.md.
Put <strong style="color: #ff6bed">repeatable actions</strong> in skills.
</div>

<div class="absolute bottom-4 right-8 text-xs op-40">vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals</div>

<!--
This is the nuance I want to add to the simple rule.

Vercel built evals around Next.js 16 APIs — use cache, connection(),
forbidden(), async cookies and headers — exactly the kind of stuff models may
not know from training.

They tried a Next.js docs skill. Default behavior: 53 percent pass rate, same
as baseline. The docs were available, but the agent often never invoked the
skill. Then they added explicit AGENTS.md instructions to use the skill: 79
percent. Much better, but the wording became fragile — invoke first versus
explore first changed what the agent missed.

Then they removed the decision. They put a compressed docs index in AGENTS.md:
not the whole docs, just "here are the version-matched files, prefer retrieval
over pre-training." That hit 100 percent in their evals.

So the rule is not "skills are bad." The rule is: don't make passive framework
knowledge depend on a trigger. For broad docs, give the agent a small always-on
map. Skills are for verbs — TDD, upgrade this app, run QA, migrate these files.

CLICK — docs indexes in AGENTS.md. Repeatable actions in skills.

TRANSITION: AGENTS.md is the front door. The deeper memory needs a system. Fair warning — the kit I steal it from has a ridiculous name.
-->

---
layout: statement
transition: fade-out
---

# Forget ~~looksmaxxing~~.

<!--
[beat]

The internet spent two years on looksmaxxing — mewing, jawline, skincare.
Forget all of it. We're brainmaxxing — maxxing the one thing your agent
actually has: its context.

TRANSITION: And the kit I steal this from is called — conveniently — brainmaxxing.
-->

---

# Meet `brainmaxxing` (steal it)

<div class="text-center text-base op-80 mb-1">
  The payoff first: every session, the agent writes down what it learned — so the next one boots up <strong style="color: #ff6bed">smarter</strong>. Persistent memory, in a folder.
</div>
<div class="text-center text-xs op-50 mb-6">
  Many shapes work — this is my current favorite. MIT, ~200 stars, three months old.
</div>

<div class="grid grid-cols-[1fr_auto] gap-8 items-center max-w-6xl mx-auto">

<div>

<TalkCardGrid
  class="mb-6"
  max-width="max-w-none"
  :cards="[
    { title: '<code>brain/</code>', body: 'a markdown vault', variant: 'muted' },
    { title: '6 skills', body: 'read &amp; write the vault', variant: 'muted' },
    { title: '1 hook', body: 'loads the map on startup', variant: 'muted' },
  ]"
/>

<img src="/brainmaxxing-repo.png" class="rounded-lg shadow-2xl" />

</div>

<TalkQrLink image="/qr-brainmaxxing.png" label="github.com/<br/>poteto/brainmaxxing" />

</div>

<!--
Many shapes work — AGENTS.md alone, cursor rules, docs/ folders. None wrong.
This one is just my current favorite. brainmaxxing is an open-source kit from
poteto. MIT, ~200 stars. Tagline: "stupid simple persistent memory and skill
improvement."

Three pieces: a brain/ folder of plain markdown the agent reads from and writes
back to; six skills that read or write the vault; and a SessionStart hook that
injects brain/index.md every new session so the agent boots up knowing the map.

Don't adopt it wholesale — steal the shape. The hook is six lines of shell.

TRANSITION: Here's what brain/ actually looks like on disk.
-->

---

# Inside `brain/`

<div class="grid grid-cols-2 gap-6 mt-6">

<Card variant="muted">
<div class="text-xs op-60 mb-2">The vault on disk</div>

```text
brain/
├── codebase/
│   ├── slide-gotchas.md
│   ├── theme-system.md
│   └── …
├── plans/
│   └── roadmap.md
├── principles/
│   ├── fix-root-causes.md
│   ├── prove-it-works.md
│   └── …
└── index.md
```

</Card>

<Card glow>
<div class="text-xs op-60 mb-2"><code>index.md</code>. The only file always loaded.</div>

```md
# Brain

## Codebase
- [[codebase/theme-system]]
- [[codebase/slide-gotchas]]

## Plans
- [[plans/roadmap]]

## Principles
- [[principles/fix-root-causes]]
- [[principles/prove-it-works]]
```

</Card>

</div>

<!--
The whole thing on disk. Plain markdown. No magic.

LEFT — one folder. codebase/ is what THIS repo actually does. plans/ is what
we're working towards. principles/ — coming up.

RIGHT — index.md. A list of wikilinks. No content inlined.

The SessionStart hook cats index.md into every conversation. The agent sees the
MAP, not the territory. When it needs theme details, it follows the wikilink.
When it doesn't, that file never enters the window. Whole vault available,
almost nothing loaded. That's guard-the-context-window in practice.

TRANSITION: So what reads and writes this vault? Skills.
-->

---

# Skills: recipes the agent opens when triggered

<div class="grid grid-cols-2 gap-8 max-w-5xl mx-auto mt-8">

<div>

<div class="text-xs op-50 mb-2"><code>.claude/skills/reflect/SKILL.md</code></div>

```yaml
---
name: reflect
description: >-
  Reflect on the conversation and update
  the brain. Use when wrapping up, after
  mistakes or corrections.
  Triggers: "reflect", "remember this".
---

# Reflect

Review the conversation and persist
learnings to `brain/`.
…
```

</div>

<div class="text-sm op-80 leading-relaxed">

<div class="text-base font-bold mb-4" style="color: #ff6bed">How it loads</div>

<div class="mb-3"><strong style="color: #ff6bed">1.</strong> At startup, the agent reads only <em>name + description</em>.</div>

<div class="mb-3"><strong style="color: #ff6bed">2.</strong> When your prompt matches, the body loads.</div>

<div class="mb-3"><strong style="color: #ff6bed">3.</strong> Scripts and references load only if the body opens them.</div>

<div class="text-xs op-50 mt-6">Open format. Same <code>SKILL.md</code> runs in Claude Code, Cursor, Codex, Copilot. ~30 agents.</div>

</div>

</div>

<!--
A skill is a named recipe the agent opens when it needs it. Frontmatter on top —
name + description. Markdown body below.

At startup the agent does NOT load the whole cookbook. It only sees the menu —
names and one-line descriptions. Progressive disclosure for actions. When your
prompt matches a description, the body loads. When the body says "run
scripts/extract.py", THEN the script loads. Three levels of lazy loading — so
skills scale.

But this is where the Vercel caveat matters: skills are great for triggered
procedures, not passive framework documentation. If the agent must decide
whether to open your docs before it knows it is confused, you already lost a
coin flip. Keep the docs map in AGENTS.md; keep the workflow here.

This is brainmaxxing's /reflect — the actual file. End of session, the agent
scans the conversation and distils what mattered back into brain/.

And before you write one — browse skills.sh. Vendors publish theirs. Vercel's
React best-practices. Anthropic's frontend-design. Free recipes from the
platform owners.

TRANSITION: Skills are buttons you press. Hooks fire whether you press anything or not.
-->

---

# Hooks: code that runs around agent events

<div class="grid grid-cols-2 gap-6 mt-6">

<div>

<div class="text-xs op-50 mb-2"><code>.claude/settings.json</code></div>

```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "startup|resume",
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/inject-brain.sh"
      }]
    }]
  }
}
```

<div class="text-xs op-50 mb-2 mt-3"><code>inject-brain.sh</code></div>

```bash
#!/bin/bash
INDEX="$CLAUDE_PROJECT_DIR/brain/index.md"
[ -f "$INDEX" ] && cat "$INDEX"
```

</div>

<div class="flex flex-col gap-3">

<div class="text-xs op-50 mb-1">The 4 events you'll actually use</div>

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">SessionStart</strong> — inject context (what brainmaxxing does)</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">PreToolUse</strong> — gate destructive Bash, lock down paths</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">PostToolUse</strong> — re-lint or re-index after writes</div>
</Card>

<Card variant="muted" size="sm">
<div class="text-sm"><strong style="color: #ff6bed">UserPromptSubmit</strong> — enrich the prompt before the model sees it</div>
</Card>

</div>

</div>

<!--
Skills are buttons you press. Hooks fire automatically when an event happens in
the agent loop. The easiest sentence: when this event happens, run this handler.

LEFT — the actual brainmaxxing config. SessionStart wires inject-brain.sh.
Every new session, before the agent's first reply, that script runs. It cats
brain/index.md to stdout. Claude Code captures stdout and prepends it as
context. That's the trick — "before any session, show the agent the map."

RIGHT — the four events you'll actually use. SessionStart, PreToolUse,
PostToolUse, UserPromptSubmit. Codex got hooks in May 2026. Cursor next. Open
pattern now.

TRANSITION: And a hook doesn't just inject context — it can say no.
-->

---

# A hook can hard-block the agent

<div class="text-center text-sm op-60 mb-4">Real <code>PreToolUse</code> hook from the app — the agent literally can't write <code>else</code>.</div>

```ts
// .claude/hooks/pre-tool-no-else.ts — runs before every Write/Edit
if (violations.length > 0) {
  const output: SyncHookJSONOutput = {
    hookSpecificOutput: {
      hookEventName: 'PreToolUse',
      permissionDecision: 'deny',   // ← the edit is rejected
      permissionDecisionReason:
        `🚫 BLOCKED: code contains 'else'. Use early returns or a ternary.`,
    },
  }
  stdout.write(JSON.stringify(output)); exit(0)
}
```

<div class="text-center text-sm op-60 mt-4">Siblings ban <code>as</code> casts and non-<code>pnpm</code> commands; a <code>PostToolUse</code> hook runs <code>tsc</code> after every edit.</div>

<!--
The brainmaxxing hook just injected context. Hooks can do far more — they can
say NO.

This is a real PreToolUse hook from the workout tracker. Before every Write or
Edit, it scans the code the agent is about to write. If it contains else or
if-else, it returns permissionDecision: 'deny' — the edit never happens, and the
agent is told to use early returns instead.

Siblings ban `as` casts and block any Bash that isn't pnpm; a PostToolUse hook
runs the type-checker after every single edit. Guardrails the agent cannot
ignore or forget — enforcement, not hope.

TRANSITION: Dozens of events. Don't memorize them. Here's the map.
-->

---
layout: image
image: /claude-code-lifecycle.svg
backgroundSize: contain
---

<!--
You don't need to memorize this. The point is the surface area — there are
dozens of points where the harness hands you JSON and lets you decide what
happens next.

The four I use daily are SessionStart, PreToolUse, PostToolUse,
UserPromptSubmit. The rest are there when you need them.

TRANSITION: Skills you call. Hooks fire. Combine both with a folder — that's brainmaxxing.
-->

---
clicks: 7
---

<BrainmaxxingLoop :step="$clicks" />

<!--
brainmaxxing: skills + hooks + a brain/ folder. Walk the loop one click at a
time, then zoom out.

CLICK 1 — "work with Claude". You're in a session.
CLICK 2 — the writers. /reflect captures what just happened at session end.
          /ruminate mines past conversations for corrections and preferences
          that never got captured. Both feed brain/.
CLICK 3 — brain/. A markdown vault. Also an Obsidian vault — browse it yourself.
CLICK 4 — /plan and /review READ principles back out. Apply them next session.
CLICK 5 — /meditate. Audits skills against the brain, evolves principles,
          prunes stale notes.
CLICK 6 — the hooks. PostToolUse re-indexes brain/ on every write. SessionStart
          cats index.md into the next session. The arrows are wishes; the hooks
          are the mechanism.
CLICK 7 — zoom out. The whole loop, lit up. That's brainmaxxing.

TRANSITION: Six skills run on top of this vault.
-->

---
layout: default
---

# Six skills + sixteen principles — one vault

<div class="grid grid-cols-2 gap-8 max-w-5xl mx-auto mt-8">

<div>
<div class="text-xs op-50 mb-3">Skills that keep <code>brain/</code> alive — each reads, writes, or cleans it</div>
<TalkCardGrid
  compact
  max-width="max-w-none"
  :cards="['/plan', '/review', '/reflect', '/meditate', '/ruminate', '/brain'].map(title => ({ title, glow: true }))"
/>
</div>

<div>
<div class="text-xs op-50 mb-3">16 principles, built in — the four I lean on daily</div>
<TalkCardGrid
  :columns="2"
  compact
  max-width="max-w-none"
  :cards="[
    'guard-the-context-window',
    'fix-root-causes',
    'subtract-before-you-add',
    'prove-it-works',
  ].map(title => ({ title, glow: true }))"
/>
<div class="text-xs op-50 mt-3">+ 12 more — each a rule, a why, a pattern, and tests. Full vault on the QR.</div>
</div>

</div>

<div class="absolute bottom-4 right-8">
  <TalkQrLink image="/qr-brainmaxxing.png" label="full vault" small />
</div>

<!--
Two things run on top of the vault: six skills and sixteen principles.

The skills, left — each reads brain/, writes to it, or cleans it. Per task:
/plan before code, /review after, /reflect at session end. Periodically:
/meditate prunes stale notes, /ruminate mines old conversations. Every loop,
brain/ gets sharper.

The principles, right — sixteen, built in. The four I lean on daily:
guard-the-context-window (why AGENTS.md stays small), fix-root-causes (fix the
factory, not the PR), subtract-before-you-add, prove-it-works (no test, it
doesn't work). Each principle file is a rule, a Why, a pattern, applications and
tests — not just a name. These aren't novel; they're what every senior engineer
learned the hard way, written down for you. A year of rediscovery, saved.

TRANSITION: Zoom out — where is all this going?
-->

---
transition: fade
---

# My take: soon, every harness ships this

<div class="text-sm op-70 text-center mb-6 max-w-3xl mx-auto">
Claude Code already shipped <code>auto memory</code>.
</div>

<div class="grid grid-cols-2 gap-6">

<Card variant="muted">
<div class="text-xs op-60 mb-2">The memory store on disk</div>

```text
.claude/memory/   # workout tracker — agent-written TILs
├── shadcn-theming-primary-color.md
├── vue-style-guide-compliance.md
├── til-composable-commands.md
└── til-claude-code-docs-agent.md
```

</Card>

<Card glow>
<div class="text-xs op-60 mb-2"><code>shadcn-theming-primary-color.md</code></div>

```md
---
name: shadcn-theming-primary-color
description: Theme via CSS variables; never
  hardcode hex in components.
metadata:
  type: feedback
---

The primary color is set once as a CSS
variable (--primary). Components use the
semantic token, never a raw hex value.

Why: enforced by the custom `no-hardcoded-colors`
ESLint rule — raw hex breaks dark mode and theming.

How to apply: reach for `bg-primary` / `text-primary`;
the lint rule fails the commit on a literal hex.
```

</Card>

</div>

<!--
Quick zoom-out before we leave memory.

Anthropic shipped this whole pattern into Claude Code itself. Auto memory
writes notes during your session — like /reflect. On by default. No skills, no
hooks. My bet: Cursor next, Codex right after. Within a year, "your agent has
persistent memory" is a checkbox feature, not a project you adopt.

But here's the open question. Built-in memory is machine-local —
~/.claude/projects. Not shared across machines or teammates. So MY agent gets
smarter from MY mistakes. The new hire on Monday starts from zero.

brainmaxxing solves this by accident — brain/ is a folder in the repo. Check it
in. The whole team's agent boots up with the same vault on day one. That's the
bet I'm making.

TRANSITION: One more context trick — bigger than memory.
-->

---
transition: fade-out
---

# Want VueUse-style composables?

<v-click>

# Give the agent VueUse.

</v-click>

<!--
[pause]

Hot take. Agents are post-trained on READING CODE. Not reading prose docs.
Stale docs in their training data are noise. Real source in your tree is signal.

CLICK — If you want the agent to write like VueUse, let it READ VueUse.

TRANSITION: One command. Try it tomorrow.
-->

---

# Vendor the library

<div class="text-sm op-60 mb-4">Pull the source into your repo as a git subtree.</div>

```bash
git subtree add --prefix=repos/vueuse \
  https://github.com/vueuse/vueuse main --squash
```

<div class="mt-4 text-sm op-60 mb-2">Then point AGENTS.md at it:</div>

```md
## Reference repositories

- `repos/vueuse/` — when writing new composables, mirror the
  patterns in `repos/vueuse/packages/core/use*/`.
- `repos/pinia/` — store patterns & private-state idioms.
- `repos/nuxt/` — module & plugin conventions.
```

<div class="text-xs op-60 mt-5 max-w-4xl">
Two follow-ups: hide <code>repos/</code> from your editor (<code>autoImportFileExcludePatterns</code> + <code>files.exclude</code>) so it never auto-imports internals — and have the agent <strong style="color:#ff6bed">distill once</strong> into <code>agent-patterns/vueuse.md</code>, so next session loads that, not 800 composables.
</div>

<div class="absolute bottom-4 right-8 text-xs op-40">
Credit: <a href="https://effect.website/blog/the-one-weird-git-trick-that-makes-coding-agents-more-effect-ive/">effect.website — The One Weird Git Trick</a>
</div>

<!--
One command. Vendors VueUse into your repo as a squashed subtree. Then one line
in AGENTS.md: "mirror these patterns."

CLICK — Why a subtree, not a submodule? No clone-time pain. Just files. Why not
point at node_modules? Compiled and flattened — the structure agents need is
gone. And agents are deoptimized from reading gitignored directories anyway.

Result — the agent's pattern matching is anchored on real code. Pattern
matching beats prompting.

Same trick steals feedback loops too: clone a repo you admire, ask "how do they
test this?", copy the approach. I packaged it as a skill — clone-repo. Credit:
the Effect team's blog post by Maxwell Brown.

Two follow-ups, on the footer line: hide repos/ from the editor so VSCode
doesn't auto-import VueUse internals into your app — four lines in
.vscode/settings.json — and once the agent has explored the source, have it
distill what it learned into agent-patterns/vueuse.md so the next session loads
that instead of re-reading 800 composables.

TRANSITION: Context loads the room. Bucket two — how the agent knows when it's wrong.
-->

---
transition: fade
---

<PartSlide
  part="2"
  title="Feedback Loops"
  subtitle="Backpressure: types, lint, tests"
/>

<!--
[scan room]

Bucket two — and this is the fix for my problem two, the fear. If an agent
doesn't know when it broke something, it ships whatever compiles. Tests are
permission to let the agent move fast — because if it breaks something, you both
find out instantly.
-->

---

# Layer 1: Type safety

<div class="text-sm op-60 mb-4">The first lie-detector. Catch the bug before it runs.</div>

<div class="grid grid-cols-2 gap-6">

<div>

```ts
// tsconfig.app.json — strict comes from @vue/tsconfig
{
  "compilerOptions": {
    "strict": true,
    "noUnusedLocals": true
  }
}
```

</div>

<div>

```ts
// Real import boundary: settings/utils/validation
const exportDataSchema = z.object({
  version: z.number().int().min(1).max(100),
  exportedAt: z.string().datetime(),
  data: z.object({
    workouts: z.array(workoutSchema).max(5000),  // DoS cap
    templates: z.array(templateSchema).max(100),
  }).strict(),                                    // reject unknown keys
}).strict()
```

</div>

</div>

<!--
Layer 1 — type safety. Strict tsconfig is non-negotiable. The real app inherits
strict from @vue/tsconfig and adds noUnusedLocals; noUncheckedIndexedAccess and
exactOptionalPropertyTypes are good stretch goals if your ecosystem can land them.

But types are a compile-time fiction. At every untyped boundary — fetch
responses, route params, import/export, form input — parse with Zod. The real
example here is the data-export schema: .strict() rejects unknown keys (a
prototype-pollution guard) and .max() caps array sizes (a DoS guard).
TypeScript trusts the types you write; the schema checks the runtime data
actually matches. With parsing in place, the agent stops reaching for `as`.

TRANSITION: Layer 2 — lint and format. Fast enough to run on every keystroke.
-->

---

# Layer 2: Lint & format

<div class="text-sm op-60 mb-4">Oxlint + Oxfmt. Fast enough to run on every keystroke.</div>

<div class="grid grid-cols-2 gap-6">

<Card glow>
<div class="text-xs op-60 mb-1">Oxlint</div>
<div class="text-2xl font-bold mb-2" style="color: #ff6bed">~50× faster</div>
<div class="text-xs op-70">Rust-based. Covers the high-value rules. Pair with ESLint for the long tail.</div>
</Card>

<Card glow>
<div class="text-xs op-60 mb-1">Oxfmt</div>
<div class="text-2xl font-bold mb-2" style="color: #ff6bed">~30× faster</div>
<div class="text-xs op-70">Prettier-compatible defaults. Drop-in replacement.</div>
</Card>

</div>

<div v-click class="mt-6">

```bash
# Vite+ wraps both behind one CLI
vp check     # type + lint + format
vp test      # vitest
vp build     # rolldown
```

</div>

<!--
Layer 2 — lint and format. Oxlint is roughly 50x faster than ESLint, Oxfmt 30x
faster than Prettier. That speed matters: lint becomes something you run on
every keystroke, not something the agent batches at the end.

Oxlint's rule set is smaller but covers the high-value cases. Fast first pass;
keep ESLint for the rules Oxlint doesn't ship yet.

CLICK — Vite+ is VoidZero's unified toolchain. One CLI, one config, wrapping
Vite, Rolldown, Vitest, Oxlint, Oxfmt, Tsdown.

TRANSITION: Speed matters — but what you lint FOR matters more. Two Vue rules in particular.
-->

---
transition: fade-out
---

# Vue lint rules that keep components small

<div class="text-center text-sm op-60 mb-6">Real caps from the shipped <code>eslint.config.ts</code> — not hypothetical.</div>

<div class="grid grid-cols-[1fr_auto] gap-8 items-start">

<div class="space-y-4">

<Card glow>
<div class="text-xs op-60 mb-1"><code>vue/max-template-depth</code></div>
<div class="text-sm mb-2">Cap template nesting. Forces extraction into smaller components.</div>

```ts
'vue/max-template-depth': ['error', { maxDepth: 8 }]
```
</Card>

<Card glow>
<div class="text-xs op-60 mb-1"><code>vue/max-props</code></div>
<div class="text-sm mb-2">Cap props per component. A 12-prop component is a god object pretending to be one.</div>

```ts
'vue/max-props': ['error', { maxProps: 6 }]
```
</Card>

<Card variant="muted">
<div class="text-xs op-60 mb-1">Plus, from the same real config</div>
<div class="text-xs op-80"><code>complexity: 10</code> · <code>consistent-type-assertions: 'never'</code> (bans every <code>as</code>) · <code>vue/no-unused-properties</code></div>
</Card>

</div>

<TalkQrLink
  image="/qr-eslint.png"
  label="Full opinionated setup<br/>alexop.dev/posts/<br/>opinionated-eslint-<br/>setup-vue-projects"
/>

</div>

<!--
Speed is one thing — what you LINT for is another. The fix for "it ignored my
conventions" is to stop describing them and start enforcing them.

ONE: vue/max-template-depth. Cap nesting at 8. The moment a template goes
deeper, ESLint screams. That's how you avoid the 800-line component with seven
layers of divs — the kind the agent gets lost in.

TWO: vue/max-props. Cap props at 6. A 12-prop component isn't a component —
it's a god object pretending to be one.

Plus the dead-code trio. The key move: the agent runs lint itself, reads the
violation, fixes it — I'm not repeating "small components, please" for the
hundredth time. A rule encoded once is a mistake the agent can't make again.

Full writeup — 20+ rules — on the QR.

TRANSITION: Stock rules are table stakes. The real unlock is rules YOU write.
-->

---

# 5 custom lint rules that teach the agent

<div class="text-center text-sm op-60 mb-4">The real <code>eslint-local-rules/</code> in the app — conventions made machine-checkable.</div>

```ts {3|5|7|all}
// eslint-local-rules/index.ts — hand-written, project-specific
export default { rules: {
  'composable-must-use-vue':    composableMustUseVue,    // a use* fn must touch Vue reactivity
  'extract-condition-variable': extractConditionVariable, // name complex booleans
  'no-hardcoded-colors':        noHardcodedColors,       // semantic tokens, no raw hex
  'no-let-in-describe':         noLetInDescribe,         // no shared mutable test state
  'repository-trycatch':        repositoryTryCatch,      // every repo call wrapped in tryCatch()
}}
```

<div class="text-center text-lg mt-6 op-80">
A convention the agent keeps breaking? <strong style="color: #ff6bed">Make it a lint rule it can't break.</strong>
</div>

<div class="text-center text-sm op-50 mt-3">
Remember "fix the factory, not the PR"? <strong style="color: #ff6bed">This is it</strong> — in its smallest form.
</div>

<!--
Stock vue/* rules are table stakes. The real unlock: rules I wrote myself,
specific to this codebase. Five of them, in eslint-local-rules/.

composable-must-use-vue catches the agent naming a plain helper use-something.
no-hardcoded-colors steers it to semantic tokens. repository-trycatch forces my
Result-style error handling on every data call.

Each one started as a mistake the agent made twice. Now it can't make it again —
the build goes red. This is "fix the factory" in its smallest form; we come back
to it in Act III.

TRANSITION: Lint catches shape. Tests catch behavior. Layer 3.
-->

---
layout: two-cols-header
---

# No hidden throws: Result-style TypeScript

<div class="text-sm op-60">try/catch jumps away from the happy path. <code>tryCatch()</code> makes both paths explicit.</div>

::left::

<div class="text-sm op-60 mb-2 mt-4">Hidden control flow</div>

```ts
try {
  const result = await getWorkoutsRepository()
    .getHistory({ limit: 100 })
} catch (error) {
  notify(error.message)
}
```

::right::

<div class="text-sm op-60 mb-2 mt-4">Explicit Result tuple: <code>[Error, null] | [null, data]</code></div>

```ts
const [error, result] = await tryCatch(
  getWorkoutsRepository().getHistory({ limit: 100 }),
)

if (error) return notify(error.message)
```

<!--
try/catch is JavaScript's built-in "jump to this block if something throws".
That is useful, but the error flow is hidden in a separate block.

In this app, the convention is tryCatch: it returns an error-first Result tuple.
Failure is [Error, null]. Success is [null, data]. It is Rust-ish, but the point
is not copying Rust syntax. The point is making the unhappy path explicit in the
same place as the data path.

TRANSITION: A convention is only as good as its enforcement. Next: make it machine-checkable.
-->

---

# The convention, machine-checked

<div class="text-sm op-60 mb-4">A custom ESLint rule turns the <code>tryCatch()</code> convention into a build error.</div>

```ts {2-5}
// eslint-local-rules/repository-trycatch.ts
if (!isRepoMethodCall(node.argument)) return
if (isWrappedInTryCatch(context, node)) return

context.report({ messageId: 'missingTryCatch' })
```

<div class="text-center text-xl mt-12 op-80">
The agent does not remember this convention. <strong style="color: #ff6bed">ESLint does.</strong>
</div>

<!--
The custom ESLint rule makes the convention machine-checkable. Any awaited
get-star-Repository call that is not inside tryCatch fails lint, with a message
telling the agent exactly what pattern to write.

That is the whole trick: the agent does not need to remember the convention,
because the linter reminds it on every run.

TRANSITION: Lint catches code shape. Tests catch behavior. Layer 3.
-->

---

# Layer 3: Unit tests

<div class="text-sm op-60 mb-4">Vitest. Watch mode. ESM-native. Same matchers as Jest.</div>

```ts
// src/__tests__/lib/plateCalculation.spec.ts — real, shipped
import { describe, it, expect } from "vitest"
import { calculatePlates } from "@/lib/plateCalculation"

describe("calculatePlates (kg)", () => {
  it("loads 100kg as two 20kg plates per side", () => {
    // (100 − 20kg bar) / 2 = 40kg/side = 20 + 20
    expect(calculatePlates(100, "kg").plates).toEqual([20, 20])
  })

  it("flags 21kg as not achievable (0.5kg/side)", () => {
    expect(calculatePlates(21, "kg").isAchievable).toBe(false)
  })
})
```

<!--
Layer 3 — unit tests with Vitest. Pure functions, hooks, stores, composables.
Anything you can call without mounting a component.

Vitest runs in watch mode while you code, everything in CI. High coverage of
pure modules. Don't chase coverage on UI glue — that's the next two layers.

Cheapest signal. Most logic lives here. The agent gets a green or red within
milliseconds of saving.

TRANSITION: Layer 4 — components, but in a REAL browser.
-->

---

# Layer 4: Component tests

<div class="text-sm op-60 mb-4">Vitest browser mode. Real Chromium via Playwright. No more jsdom.</div>

```ts
// src/__tests__/components/.../NumericKeypad.spec.ts — real Chromium
import { render } from "vitest-browser-vue"
import { page, userEvent } from "vitest/browser"
import { expect, it, vi } from "vitest"
import NumericKeypad from "@/components/ui/numeric-input/NumericKeypad.vue"

it("emits update when a digit is pressed", async () => {
  const onUpdate = vi.fn()
  render(NumericKeypad, { props: { modelValue: 20, "onUpdate:modelValue": onUpdate } })
  await userEvent.click(page.getByRole("button", { name: "5" }))
  expect(onUpdate).toHaveBeenCalled()
})
```

<div v-click class="mt-6 text-sm">
<span style="color:#ff6bed">The real unlock:</span> a failing test drops a <strong>screenshot of the rendered UI</strong> — and Claude is multimodal, so it <em>sees</em> the broken frame. It debugs by looking at the screen, like you do.
</div>

<!--
Layer 4 — component tests in a REAL browser. The biggest win in 2026. Vitest
browser mode runs your component tests in a real Chromium via Playwright instead
of jsdom.

Hover states. Focus. Layout. Intersection observers. Scroll. All work as they
do in production. The agent can finally trust that "passes in tests" means
"works in the browser."

CLICK — and here's the part that matters for an AGENT specifically: when a test
fails, browser mode captures a screenshot of the actual rendered UI. And Claude
is multimodal — it doesn't just read "expected true, got false," it looks at the
picture. "The keypad is rendering behind the modal." "The label clipped." "The
empty state never showed." jsdom gave the agent a stack trace; browser mode gives
it eyes. It debugs the way I would — by looking at the screen. That's the loop
closing on the one thing it could never see before: how the app actually looks.

TRANSITION: Four layers of signal — but signal the agent can ignore. Next: make the discipline non-skippable.
-->

---

# TDD: a skill the agent can't skip

<div class="text-sm op-60 mb-4">A line in CLAUDE.md is a polite request. The agent reads "write tests first," nods, and ships the happy path anyway. Make RED structural.</div>

<div class="grid grid-cols-2 gap-8 max-w-5xl mx-auto mt-6">

<div>

<div class="text-xs op-50 mb-2"><code>.claude/skills/tdd/SKILL.md</code></div>

````md magic-move
```md
# TDD — mandatory 3-phase cycle

Do NOT skip phases.

## 1. RED — write a failing test
Delegate to the `tdd-test-writer`
subagent. Do NOT proceed until you
have seen the test fail.

## 2. GREEN — make it pass
Delegate to the `tdd-implementer`.

## 3. REFACTOR — clean up
Delegate to the `tdd-refactorer`.
```
```md
## Never

- Write code before the test
- Reach GREEN without seeing RED fail
- Start a feature mid-cycle

Each phase runs in its own subagent —
so RED can't read GREEN's intentions.
```
````

</div>

<div class="text-sm op-80 leading-relaxed">

<div class="text-base font-bold mb-4" style="color: #ff6bed">Why a skill, not a sentence</div>

<div class="mb-3"><strong style="color: #ff6bed">One window can't do TDD.</strong> The test-writer's plan bleeds into the implementer — so the model designs tests around code it already intends to write.</div>

<div class="mb-3"><strong style="color: #ff6bed">Split the phases.</strong> Each runs in its own subagent. RED has to <em>see</em> the test fail before it returns.</div>

<div class="mb-4"><strong style="color: #ff6bed">Force the evaluation.</strong> A <code>UserPromptSubmit</code> hook makes the agent weigh its skills before it codes — so "use TDD" stops being optional.</div>

<div class="text-xs op-50">Integration over mock-heavy units: assert what the user sees (<code>getByRole</code>, a route change), not how the code is wired.</div>

</div>

</div>

<div class="absolute bottom-4 right-8 text-xs op-40">alexop.dev/posts/custom-tdd-workflow-claude-code-vue</div>

<!--
Layer 4 trusted the browser. This slide is the honest gap behind it: the abstract
promises Skills enforce TDD — but a line in CLAUDE.md is a polite request, and
Claude Code defaults to implementation-first.

And it's structural, not motivational. A single context window can't really do
TDD — the test-writer's analysis leaks into the implementer, so the model quietly
designs the tests around the code it already planned.

So I made TDD a skill. The body is a mandatory three-phase cycle: RED, GREEN,
REFACTOR, each delegated to its own subagent so the phases can't see each other.
The test-writer literally has to watch the test fail before it returns.
CLICK — and a hard "never" list: no code before a failing test, no GREEN without
RED.

The trick that makes it non-skippable is the UserPromptSubmit hook from earlier —
it forces the agent to evaluate its skills before it codes, instead of hoping it
remembers. Honest gap: it's not 100%, and wiring it up is real work. But it's
enforced, not wished-for.

TRANSITION: And that discipline is only one layer of feedback.
-->

---
clicks: 4
transition: fade-out
---

# One delegate. Nine red/green/refactor turns. Clean context.

<div class="text-center text-sm op-60 mb-3">Hand the whole feature to a nested <code>tdd-orchestrator</code> — nine red/green/refactor turns happen two levels down, your context never sees them.</div>

<TddNestedFlow :step="$clicks" />

<!--
The TDD skill from the last slide had a hidden cost: if the MAIN chat runs the
three phases, every test failure, every diff, every refactor lands in your one
context window. Five features in, it's a swamp.

Nested subagents fix the shape. CLICK — you ask the main chat for the Set Logger,
three acceptance criteria. CLICK — it doesn't write a line. It hands the WHOLE
feature to the tdd-orchestrator, one nested subagent.

Now watch the right side. CLICK — AC1, RED: the orchestrator spawns tdd-test-writer
in its OWN fresh context. The test fails — it has to SEE red. CLICK — GREEN:
tdd-implementer, separate context, makes it pass. CLICK — REFACTOR: tdd-refactorer
cleans up, tests stay green. CLICK, CLICK — AC2 and AC3 run the same loop.

CLICK — the orchestrator returns ONE summary: 3 of 3 green, 9 tests. Look at the
left lane: the main chat saw two messages — "build it" and "done." The nine
red/green/refactor turns happened two levels down and never polluted the context
you're actually steering from.

That's the whole trick: delegation isn't just parallelism, it's context hygiene.
The orchestrator is a disposable workspace.

TRANSITION: And that discipline is only one layer of feedback.
-->

---

# 15 layers of feedback

<div class="text-center text-sm op-60 mb-4">You've seen 4. There are 11 more. Every layer is a signal the agent can chase.</div>

<div class="grid grid-cols-[1fr_auto] gap-8 items-center">

<div>
  <img src="/quality-pipeline-layers.png" class="rounded-lg shadow-2xl" />
</div>

<TalkQrLink
  image="/qr-quality-pipeline.png"
  label="Full breakdown<br/>alexop.dev/posts/<br/>modern-frontend-<br/>quality-pipeline"
/>

</div>

<!--
You've seen the first 4: types, lint, unit, component.

The other 11: API mocking, contract testing, E2E, a11y, visual regression,
performance, dead code, i18n drift, preview deploys, AI code review,
observability.

Every one is a signal the agent can chase. The cheap ones at the center run on
every save. The expensive ones at the edge run in CI or prod. Full stack on my
blog — QR.

TRANSITION: And in the real app, this isn't a diagram — it's wired up.
-->

---

# Not a slogan — the real numbers

<div class="text-center text-sm op-60 mb-4">All from the workout tracker — the app I "didn't type."</div>

<TalkCardGrid
  :columns="2"
  max-width="max-w-none"
  :cards="[
    { eyebrow: 'Tests', value: '906', body: 'cases · 95 files · 4 Vitest projects (default · a11y · visual · arch)', glow: true },
    { eyebrow: 'CI jobs', value: '13', body: 'lint · knip · type-check · 4 test shards · arch · a11y · visual · perf', glow: true },
    { eyebrow: 'Lighthouse budget (gated in CI)', value: 'a11y 1.0', body: 'perf ≥ 0.80 · LCP ≤ 3.5s · CLS ≤ 0.1', glow: true },
    { eyebrow: 'Coverage gate', value: '80%', body: 'lines / functions / statements · 75% branches', glow: true },
  ]"
/>

<!--
The 15 layers aren't a diagram — they're wired up in the real app. 906 tests
across four Vitest projects. A 13-job CI: sharded tests, archunit boundaries,
axe-core a11y, visual regression, Lighthouse budgets where accessibility must
score a perfect 1.0. Coverage gated at 80%.

This is what "tests are permission to let the agent move fast" looks like —
that's how much signal the agent has to chase before anything merges.

Reminder: re-run `pnpm test` in the workout-tracker repo and confirm the
on-slide figure (906 tests / 95 files) is current before presenting.

TRANSITION: Those 15 are automated. There's one more, and it's different.
-->

---
clicks: 3
transition: fade-out
---

# Beyond the 15: the agent as a user

<div class="text-center text-sm op-60 mb-4">Static checks are green. Did it <em>work</em> in a browser?</div>

<AgentBrowserLoop :step="$clicks" />

<div v-after class="mt-4 max-w-3xl mx-auto">

<Card variant="muted">
<div class="text-sm op-90 text-center">
Run the app locally <strong style="color: #ff6bed">+</strong> drive a real browser <strong style="color: #ff6bed">=</strong> the agent verifies its own PR like a user.<br/>
Types passing isn't shipping. <em>Working in a browser</em> is shipping.
</div>
</Card>

</div>

<!--
[breathe]

Fifteen automated layers, all green. The PR looks clean. But did the feature
actually WORK? Did the modal open? Did the form submit? Did the chart render
with the right data? Static checks can't answer that. You need the agent to BE
the user.

Two ingredients. ONE — an agent-runnable Vue app: dev server is ONE command,
port is STABLE, there's a way to know "server is ready", test data is seeded, no
surprise cookie banners. Deterministic. TWO — a real browser the agent can
drive, which is exactly the tool on the next slide.

CLICK — So the loop becomes: agent writes code, types pass, lint passes, tests
pass, THEN the agent opens the app, runs the change, screenshots it, reads the
console. If anything's wrong, it goes back. This is the click-through-by-hand
step, automated — and it's what killed my fear.

TRANSITION: But a user clicks at random. A QA engineer works from a ticket.
-->

---
transition: fade-out
---

# Aim it like a QA engineer — from a ticket

<div class="text-center text-sm op-60 mb-6">A QA engineer never hears "test the app." They get a <strong style="color:#ff6bed">ticket</strong> — and they do two jobs with it.</div>

<div class="grid grid-cols-[0.82fr_1.18fr] gap-7 items-stretch max-w-6xl mx-auto">

<Card variant="muted">
<div class="text-xs uppercase tracking-wide op-50 mb-2">The ticket · the contract</div>
<div class="text-base font-semibold mb-1">#142 · Auto-start rest timer</div>
<div class="text-xs op-70 mb-4">Resume an in-progress workout; rest countdown starts on its own.</div>
<div class="text-xs op-50 mb-1">Acceptance criteria</div>
<div class="text-xs op-85 leading-relaxed">
  <div>AC1 · resume restores the in-progress workout</div>
  <div>AC2 · rest countdown auto-starts on log-set</div>
  <div>AC3 · footer shows <code>Rest m:ss</code>, counting down</div>
  <div class="op-50 mt-1">… 7 criteria total</div>
</div>
</Card>

<div class="grid grid-rows-2 gap-4">

<Card glow>
<div class="text-xs uppercase tracking-wide op-50 mb-1">Job 1 · Verify the criteria</div>
<div class="text-xl font-bold">Walk every AC in the live app.</div>
<div class="text-sm op-75 mt-2">Did AC2 <em>actually</em> happen in a real browser? Pass / fail, with a screenshot. A checklist, not a vibe.</div>
</Card>

<Card glow>
<div class="text-xs uppercase tracking-wide op-50 mb-1">Job 2 · Explore</div>
<div class="text-xl font-bold">Poke at what the ticket never mentioned.</div>
<div class="text-sm op-75 mt-2">"Simultaneous learning, test design, and execution." The bug <em>no</em> acceptance criterion would ever catch.</div>
</Card>

</div>

</div>

<div class="absolute bottom-4 right-8 text-xs op-40">alexop.dev/posts/exploratory-qa-ai-agents-site-agnostic-harness</div>

<!--
[breathe]

Before any tooling — what are we actually asking the agent to be? Not "a user
who clicks around." A QA engineer. And a QA engineer never gets "test the app."
They get a TICKET — and they do two distinct jobs with it.

LEFT — the ticket is the contract. Ticket #142: resume a workout, auto-start the
rest timer. Underneath, the acceptance criteria — the explicit checklist.
This is where the "7 acceptance criteria" you'll see in a minute COME FROM. Not
invented by the agent. Read off the ticket, like a real engineer would.

RIGHT — two jobs, and they're different.
JOB 1, verify the criteria: walk every AC against the LIVE app. Did AC2 actually
happen in a real browser? Pass or fail, with a screenshot. Deterministic. A
checklist.
JOB 2, explore: this is the one scripted E2E can never do. The textbook
definition — exploratory testing is "simultaneous learning, test design, and
test execution," all at once. The agent wanders like a first-day QA hire and
finds the bug nobody wrote a criterion for. On otto.de, Codex found a filter
button sitting on a panel with zero products — a consistency bug no AC would
ever cover.

Hold both jobs in your head. Everything in this act is one or the other:
agent-browser is the hands, dogfood is Job 2, the PR proof is Job 1, and the
label-triggered pipeline runs both.

TRANSITION: First, the hands — the tool that lets it act at all.
-->

---
clicks: 5
transition: fade-out
---

# What `agent-browser` really gives the agent

<div class="text-center text-sm op-60 mb-4">Example ask: "Go to OTTO.de, find a product, and add it to the cart."</div>

<AgentBrowserOttoFlow :step="$clicks" />

<!--
[breathe]

This is the real trick. agent-browser is not "the agent magically sees a
website." It is a command-line protocol for a real Chromium session.

CLICK 1 — The agent first bounds the task. In a real run I want it to stay on
OTTO.de, use a named session, and know the line: adding to cart is okay,
checkout or payment needs explicit confirmation.

CLICK 2 — Then it opens the page and asks for a snapshot. Snapshot is the
accessibility tree as compact text. The important part is the @refs: searchbox,
cookie button, cart link, product result, add-to-cart button.

CLICK 3 — The agent acts through those refs. It fills the search field, presses
Enter, clicks a product. No brittle Playwright selector file. It chooses from
what the browser says is currently interactable.

CLICK 4 — After every page change, the refs are stale. That is the core mental
model. Click, wait, snapshot again. The agent keeps rebuilding its map of the
page.

CLICK 5 — Cookie banners, modals, variant pickers, out-of-stock messages: these
are not special cases in the talk track. They are just the next snapshot and the
next ref.

CLICK 6 — And before it says "done", it verifies. Read visible text, read page
errors, take an annotated screenshot. The result is not "I think I clicked the
button." The result is "I saw the cart confirmation, there were zero browser
errors, here is the screenshot."

TRANSITION: So once the project runs locally AND the agent has this loop...
-->

---
transition: fade-out
---

# Yes, this slide was made by an agent

<div class="grid grid-cols-[1.05fr_0.95fr] gap-8 items-center mt-4">

<div>

<div class="text-4xl font-bold leading-tight">
I used <span style="color:#ff6bed">Codex</span><br/>
with <code>agent-browser</code><br/>
to build the slide<br/>
you just saw.
</div>

<div class="mt-6 text-lg op-75 leading-snug">
It captured OTTO.de, read the accessibility tree, checked the rendered slide,
then tightened the layout until the full story fit.
</div>

</div>

<div class="rounded-lg overflow-hidden border border-white/12 shadow-2xl" style="box-shadow: 0 24px 80px -40px rgba(255,107,237,.9)">
  <img src="/codex-agent-browser-slide-review.png" alt="Codex reviewing the generated agent-browser slide screenshot" class="w-full block" />
</div>

</div>

<!--
[smile]

And the fun part: I made that slide the same way the slide explains.

I gave Codex the task. It used agent-browser to open OTTO.de, capture real
screenshots, read the snapshot refs, build the interactive Slidev component,
run the build, open the deck in a browser, screenshot the slide, notice the
footer collision, and iterate until the whole story fit.

So this is not a diagram about a workflow. This is a receipt from the workflow.

TRANSITION: And you can package that loop into a skill.
-->

---
transition: fade-out
---

# Clone a QA engineer into `/tmp`

<div class="grid grid-cols-[1fr_16rem] gap-8 items-center mt-4">

<div>

<div class="text-xs uppercase tracking-wide op-50 mb-2" style="color:#ff6bed">Job 2 · Explore</div>

<div class="text-2xl font-bold leading-tight mb-5">
Vercel had the right instinct:<br/>
dogfood the preview like a real user.
</div>

<div class="text-lg op-75 leading-snug mb-6">
The <code>dogfood</code> skill turns one URL into an exploratory QA pass:
navigate, click, type, resize, inspect the console, and save repro evidence —
no acceptance criterion required.
</div>

<a href="https://github.com/alexanderop/dogfood-qa" class="text-sm font-mono" style="color:#ff6bed">
github.com/alexanderop/dogfood-qa
</a>

```bash
git clone https://github.com/alexanderop/dogfood-qa /tmp/dogfood-qa
cp -R /tmp/dogfood-qa/.claude/skills/dogfood .claude/skills/

# then:
# "dogfood http://localhost:3000"
```

</div>

<TalkQrLink
  image="/qr-dogfood-qa.png"
  label="github.com/<br/>alexanderop/<br/>dogfood-qa"
/>

</div>

<!--
This is the next move.

If agent-browser is the browser primitive, a dogfood skill is the reusable QA
procedure around it. Clone the repo into tmp, copy the skill into your project
or user skills, and now "dogfood this preview" means: behave like a QA engineer,
not like a screenshot script.

It clicks through the app, tests edge cases, checks console noise, records
evidence, and gives you a report a team can actually act on.

TRANSITION: Here's what that looks like when the target is OTTO.de.
-->

---
transition: fade-out
---

# What the dogfood skill gives you back

<div class="grid grid-cols-[0.92fr_1.08fr] gap-7 items-center mt-3">

<div class="space-y-4">

<Card glow>
<div class="text-xs uppercase tracking-wide op-55 mb-2">Real OTTO.de run</div>
<div class="text-5xl font-bold" style="color:#ff6bed">5</div>
<div class="text-lg font-semibold">documented findings</div>
<div class="text-sm op-70 mt-2">1 medium · 4 low · screenshots · repro video · console summary</div>
</Card>

<Card variant="muted">
<div class="text-sm font-semibold mb-2">QA-style checklist</div>
<div class="grid grid-cols-2 gap-x-4 gap-y-2 text-sm op-80">
  <div>navigation</div>
  <div>forms</div>
  <div>edge cases</div>
  <div>mobile</div>
  <div>accessibility</div>
  <div>console</div>
</div>
</Card>

<Card variant="muted">
<div class="text-xs op-65 mb-1"><code>dogfood-output/report.md</code></div>
<div class="text-sm">Every issue gets severity, category, URL, repro steps, and linked screenshots.</div>
</Card>

</div>

<div class="rounded-lg overflow-hidden border border-white/12 shadow-2xl bg-black">
  <img src="/dogfood-qa/issue-004-result.png" alt="OTTO.de dogfood QA report screenshot showing an error state with annotated browser refs" class="w-full block" />
</div>

</div>

<!--
[point at screenshot]

This is the important part: the output is not "seems fine" or "I clicked
around." It is a QA handoff.

For this OTTO.de run, the skill found five issues. The medium one was a stale or
unknown filter parameter that pushed search results into a persistent error
state. The report includes the URL, screenshots for every step, and a repro
video for the interactive bug.

That is much closer to what a QA engineer gives you: a bug you can assign, not a
vague paragraph about quality.

TRANSITION: Here's another receipt — the same loop catching a real UI bug.
-->

---
transition: fade-out
---

<TalkFramedImage src="/agent-browser-bug-reproduced.png" alt="Agent reproducing a bug via agent-browser" :shadow="false" />

<!--
[breathe]

This is the agent driving agent-browser to reproduce a real bug. Resize to
mobile, screenshot, read it back, diagnose the cause. No human in the loop — the
agent SEES the bug like a user would — exactly the "did it actually work?" check
from two slides ago, now running itself.

TRANSITION: Nice — but how do you make the agent ALWAYS do this, not just when you ask?
-->

---
transition: fade-out
---

# Make it a standing rule: `CLAUDE.md`

<div class="text-center text-sm op-60 mb-4">Don't ask for QA every time. Bake it into the agent's context once.</div>

<div class="text-xs op-50 mb-2"><code>CLAUDE.md</code> · project instructions the agent reads on every run</div>

```md
## Definition of done

A task is NOT done when the code compiles or the tests pass.
After EVERY task, before you report back, QA it in a real browser:

1. Make sure the dev server is running (`pnpm dev`, port 5173).
2. Drive the change with `agent-browser` like a user would:
   - `agent-browser open localhost:5173`
   - navigate to the feature, click / fill, take a screenshot
   - `agent-browser console` — fail on any error
3. Only report "done" once you've SEEN it work in the browser.
   If it doesn't work, go back and fix it. Don't ask me first.
```

<div class="mt-4 max-w-3xl mx-auto">

<Card variant="muted">
<div class="text-sm op-90 text-center">
Discoverability, not a prompt. The QA loop lives in the agent's context <strong style="color: #ff6bed">forever</strong> —<br/>
so "works in a browser" becomes the agent's own definition of <em>done</em>.
</div>
</Card>

</div>

<!--
[breathe]

The last slide showed WHAT the agent can do. This is how you make it do it
EVERY time — without you asking.

The trick isn't a clever prompt you retype. It's a standing rule in CLAUDE.md —
the file the agent reads on every single run. You redefine "done." Done is not
"it compiles." Done is not "the tests are green." Done is "I drove the real app
with agent-browser, clicked through the change, read the console, and SAW it
work."

And the last line matters most: if it doesn't work, fix it — don't ask me
first. That's what turns the QA step from something you remember to request into
something the agent owns. This is the Discoverability bucket from Act II, applied
to feedback: the loop you want lives in the context, not in your head.

TRANSITION: Sounds nice. Here's it actually happening on a real PR.
-->

---
transition: fade-out
---

# Proof: the agent QA'd a PR by itself

<div class="text-center text-xs uppercase tracking-wide op-50 mb-3"><span style="color:#ff6bed">Job 1 · Verify the criteria</span> — ticket #142, checked against the live app</div>

<div class="grid grid-cols-2 gap-6 mt-4">

<div>
<div class="text-xs op-50 mb-2"><code>qa-report.md</code> · autonomous run</div>

```md
# QA — auto-start rest timer + resume workout
Verdict: MINOR_ISSUES   ·   2026-04-12

✓ AC2  Auto rest countdown on log-set
       footer showed `Rest 0:07` counting down
✗ copy bug: resume dialog says "with 0 blocks"
       (the template had 1 block)
✗ a11y: countdown missing role="timer"
```

</div>

<div class="flex flex-col gap-3 justify-center">

<TalkCardGrid
  :columns="1"
  max-width="max-w-none"
  :cards="[
    { value: '70 turns', body: 'one agent · ~10.5 min wall-clock', glow: true },
    { value: '2 real bugs', body: 'found by driving the live app, no human', glow: true },
    { body: '7 acceptance criteria checked · machine-readable verdict in <code>qa-structured-output.json</code>', variant: 'muted' },
  ]"
/>

</div>

</div>

<!--
Not hypothetical — a real run from the workout tracker. And this is ticket #142
from a few slides back — the auto-start rest timer. Job 1, made real.

I handed an agent the PR and let it QA itself with agent-browser. 70 turns, about
ten and a half minutes. It checked all seven acceptance criteria FROM THE TICKET
against the LIVE app — and going beyond them (Job 2), found two genuine bugs: a
copy bug ("with 0 blocks" when the template had one) and a missing role=timer for
screen readers. Neither was in the ACs. That's the exploration paying off.

It wrote qa-report.md and a machine-readable verdict. "Types passing isn't
shipping; working in a browser is" — here's the agent proving exactly that.

TRANSITION: The laptop version works. Now we need the headless version.
-->

---
transition: fade-out
---

# First: `claude -p`

<div class="text-center text-sm op-70 mb-8">Claude Code without the chat UI.</div>

```bash
claude -p "Test this preview like a QA engineer" \
  --allowedTools "Bash(agent-browser*)"
```

<div class="mt-8 max-w-3xl mx-auto">
<Card variant="muted">
<div class="text-lg text-center leading-snug">
One prompt in. One report out.<br/>
No interactive session, no back-and-forth.
</div>
</Card>
</div>

<!--
[breathe]

This is the bridge from "I asked Claude in a terminal" to "CI can run Claude
while nobody is watching."

`claude -p` is print mode. It gives Claude Code a one-shot prompt from the
terminal. No chat UI, no interactive follow-up, no human waiting at the
keyboard. That makes it scriptable.

And scriptable is the important word. If I can run it from my terminal, GitHub
Actions can run it on a pull request.

TRANSITION: But I don't want to give CI-Claude my whole machine. I want to give
it exactly one useful tool.
-->

---
transition: fade-out
---

# Give the agent one browser tool

<div class="text-center text-sm op-70 mb-6">One narrow permission: <code style="color: #ff6bed">Bash(agent-browser*)</code></div>

<div class="grid grid-cols-3 gap-5 mt-8 max-w-5xl mx-auto">

<Card variant="muted">
<div class="text-xs uppercase tracking-wide op-50 mb-2">Step 1</div>
<div class="text-3xl font-bold" style="color:#ff6bed"><code>open</code></div>
<div class="text-sm op-75 mt-3">Load the preview deploy in real Chromium.</div>
</Card>

<Card glow>
<div class="text-xs uppercase tracking-wide op-50 mb-2">Step 2</div>
<div class="text-3xl font-bold" style="color:#ff6bed"><code>snapshot -i</code></div>
<div class="text-sm op-80 mt-3">Read the interactive accessibility tree with refs.</div>
</Card>

<Card variant="muted">
<div class="text-xs uppercase tracking-wide op-50 mb-2">Step 3</div>
<div class="text-3xl font-bold" style="color:#ff6bed"><code>click / fill / console</code></div>
<div class="text-sm op-75 mt-3">Act like a user, then inspect browser errors.</div>
</Card>

</div>

<div class="mt-7 text-center text-lg op-80">
No Playwright selectors to maintain. The agent chooses from what the browser exposes.
</div>

<!--
That permission string is the safety shape.

I am not saying "run anything you want." I am saying: you may run Bash commands
that start with agent-browser. That's enough for QA.

The loop is simple. Open the preview. Ask for an interactive snapshot. Click or
fill using the refs from that snapshot. Then snapshot again, because the page
changed and the refs are stale. At the end, read the console.

That's why this works across layout changes. The agent doesn't need my selector
file. It keeps asking the browser what is currently interactable.

TRANSITION: Now the agent can explore. CI still needs a contract.
-->

---
transition: fade-out
---

# Free text is not a CI contract

<div class="grid grid-cols-[0.9fr_1.1fr] gap-6 items-center mt-6">

<Card variant="muted">
<div class="text-xs uppercase tracking-wide op-50 mb-3">Nice for humans</div>
<div class="text-3xl font-bold leading-tight">"Looks good,<br/>no issues found."</div>
<div class="text-sm op-65 mt-4">Hard for a workflow to branch on.</div>
</Card>

<Card glow>
<div class="text-xs uppercase tracking-wide op-50 mb-3">Useful for CI</div>
<div class="text-4xl font-bold leading-tight" style="color:#ff6bed">{ verdict,<br/>summary,<br/>bugs[] }</div>
<div class="text-sm op-80 mt-4">A shape your script can read every time.</div>
</Card>

</div>

```bash
--output-format json \
--json-schema "$SCHEMA" \
| jq '.structured_output'
```

<!--
This is the deterministic part.

Claude exploring a website is naturally a little non-deterministic. It may click
different links, phrase the summary differently, or notice different details.
That's fine for exploration. It's not fine for CI.

So the contract is JSON schema. Claude still does the human-shaped work:
explore, interpret, judge severity. But the output lands in the same shape every
time: verdict, summary, bugs.

Then `jq` extracts only the structured output, and the boring script can decide
what to do next.

TRANSITION: With those three pieces, the GitHub Action becomes almost boring.
-->

---
transition: fade-out
---

# The trigger is a label

<div class="text-center text-sm op-70 mb-4">You don't QA every commit. You add a <code style="color:#ff6bed">qa</code> label to the PR — the pipeline wakes up.</div>

<div class="flex items-center justify-center gap-2 text-xs op-70 mb-5 flex-wrap">
  <span class="px-2 py-1 rounded bg-white/5">Ticket + ACs</span>
  <span style="color:#ff6bed">→</span>
  <span class="px-2 py-1 rounded" style="background:rgba(255,107,237,.15);color:#ff6bed">add <code>qa</code> label</span>
  <span style="color:#ff6bed">→</span>
  <span class="px-2 py-1 rounded bg-white/5">Action fires</span>
  <span style="color:#ff6bed">→</span>
  <span class="px-2 py-1 rounded bg-white/5">verify ACs + explore</span>
  <span style="color:#ff6bed">→</span>
  <span class="px-2 py-1 rounded bg-white/5">PR comment</span>
</div>

```yaml
on:
  pull_request:
    types: [labeled]                        # ← fires when a label is added

jobs:
  qa:
    if: github.event.label.name == 'qa'     # only the qa label, nothing else
    steps:
      - run: npm i -g agent-browser @anthropic-ai/claude-code
      - run: agent-browser install
      - run: ACS=$(gh issue view "$TICKET" --json body -q .body)   # ← the acceptance criteria
      - run: claude -p "Verify these criteria, then explore: $ACS" ...
      - run: gh pr comment "$PR" --body-file qa-report.json
```

<div class="absolute bottom-12 right-8 text-xs op-40">alexop.dev/posts/automated-qa-claude-code-agent-browser-cli-github-actions</div>

<!--
Here's the trigger — and it's the whole point.

You do NOT run a ten-minute browser agent on every commit. That's slow and
expensive. Instead it's opt-in: when a PR is ready for a real QA pass, you add
one label — `qa`. Adding the label is the human saying "this one's worth it."

The YAML: `on: pull_request, types: [labeled]` means the workflow fires the
moment a label lands. The `if` guard checks it's actually the `qa` label and not
some other tag. Then: install agent-browser and Claude Code; pull the acceptance
criteria straight off the linked ticket with `gh issue view` — that's the
`$ACS` line, the contract made literal; feed them into the `claude -p` prompt
("verify these, THEN explore"); and post the structured report back as a PR
comment. The ACs aren't vibes — they're text piped from the issue.

So the flow on the strip up top: ticket with ACs, you add the label, the Action
fires, the agent does both jobs — verify the ACs and explore — and you get a QA
report on the PR. Like having a QA engineer you summon with a label.

The schema, the longer prompt, the exact jq — all in the blog post. The slide
just needs the mental model: a label summons a QA engineer.

TRANSITION: But this is still a signal, not a human replacement.
-->

---
transition: fade-out
---

# It reports. You decide.

<div class="max-w-4xl mx-auto mt-10 text-center">

<div class="text-4xl font-bold leading-tight">
The agent does not approve the PR.
</div>

<div class="text-2xl op-75 mt-5 leading-snug">
It gives every PR a QA pass <span style="color:#ff6bed">you can read</span>.
</div>

</div>

<div class="mt-10">

<TalkCardGrid
  :columns="3"
  max-width="max-w-5xl"
  :cards="[
    { eyebrow: 'green', value: 'HEALTHY', body: 'no bugs found in the explored paths', glow: true },
    { eyebrow: 'yellow', value: 'MINOR_ISSUES', body: 'ship consciously, fix follow-ups', variant: 'muted' },
    { eyebrow: 'red', value: 'CRITICAL_BUGS', body: 'block until a human reads the repro', variant: 'muted' },
  ]"
/>

</div>

<!--
This is the honest gap, and I want to say it clearly.

The agent cannot approve the pull request. It should not be the owner of
shipping judgment. What it can do is remove the skipped-QA problem.

Every PR gets a real browser pass. Every PR gets a verdict. Every PR gets repro
steps when something breaks. Then the human returns at the right level: not
clicking around randomly, but reading a focused QA report.

TRANSITION: QA is a signal — even on every PR. A signal can be ignored. You still need a GATE.
-->

---

# The commit-time gate

<div class="text-center text-sm op-70 mb-4">A Git hook runs lint, types, and dead-code checks before bad code reaches the branch.</div>

```bash {2|3|4|all}
# .husky/pre-commit — bad code never reaches main
pnpm lint        # oxlint → eslint → markdownlint
pnpm type-check  # vue-tsc --build (project references)
pnpm knip        # dead code, unused exports & deps
```

```bash
# .husky/commit-msg — Conventional Commits, enforced
# ^(feat|fix|docs|refactor|perf|test|build|ci|chore|revert)(\(scope\))?!?: .+
```

<!--
[pause]

15 layers are signals. The pre-commit hook is the GATE. Bad code doesn't reach
main. Full stop. Lint, types, and dead-code (knip) on every commit — plus a
commit-msg hook enforcing Conventional Commits so the history stays machine- and
agent-readable.

The real workout tracker uses Husky for this. The point isn't the tool —
Lefthook is a fine alternative — it's that the gate is checked into the repo,
the agent can read and edit it, and CI mirrors the same checks.

The one rule: no --no-verify escape hatches. If a hook fails, FIX IT. The whole
point of the gate is that it doesn't open.

TRANSITION: Context, feedback — done. Bucket three: discoverability.
-->

---
transition: fade
---

<PartSlide
  part="3"
  title="Discoverability"
  subtitle="One folder = one feature"
/>

<!--
[scan room]

Bucket three — the fix for problem one, the wrong-looking code. The folder
structure is the API the agent uses to read your code. Once context is in
place, the agent can help you carve the structure too.
-->

---
layout: statement
---

# Most Vue apps start flat

<v-click>

<div class="text-lg op-70 mt-8 max-w-3xl mx-auto">Quick hands — who's got a <code>components/</code> folder that's crept past <strong style="color: #ff6bed">50 files</strong>?</div>

</v-click>

<!--
[re-engage the room after the long feedback stretch — get hands up before the diagram]

CLICK — quick hands, no judgment: who has a components/ folder that quietly
crept past fifty files? [scan] Yeah — that's most rooms. Hold that feeling, it's
exactly the pain this section fixes.

A definition before the agent angle. Flat structure groups files by file TYPE.
Components live in components/. Composables in composables/. A store is a store,
so it goes in stores/.

You run pnpm create vue, you get this. The Vue docs show it this way. Most apps
I see in the wild look exactly like this.

TRANSITION: Here's the typical scaffold.
-->

---

# The typical Vue scaffold

<div class="text-center text-xs op-50 mb-3">What a fresh Vue app grows into</div>

<div class="max-w-md mx-auto">

<FolderTree
  root
  title="src/"
  :structure="`src/
  components/
    WorkoutActiveMode.vue
    WorkoutHeader.vue
    TimerDisplay.vue
    ExerciseList.vue
    SettingsForm.vue
  composables/
    useWorkoutMode.ts
    useRestTimer.ts
    useExercises.ts
    useSettings.ts
  stores/
    workout.ts
    timers.ts
    settings.ts
  views/
  router/`"
/>

</div>

<!--
This is what most Vue projects end up looking like. Everything that IS a
component goes in components/. Everything that IS a composable in composables/.
A store is a store — stores/.

Fast to start. Zero setup. Easy to read top-to-bottom on day one.

TRANSITION: It works — until it doesn't.
-->

---
layout: two-cols-header
---

# Flat: where it works, where it breaks

::left::

<div class="text-sm mb-4" style="color: #ff6bed">Works for</div>

✅ Small apps and prototypes

✅ Zero setup &mdash; just start

✅ Easy to read top-to-bottom

::right::

<div class="text-sm mb-4" style="color: #ff6bed">Breaks when</div>

❌ <code>components/</code> swells to 80+ files

❌ One feature spans three folders

❌ Tests per feature get tricky

❌ Agents grep across the whole tree

<!--
Flat is not wrong. It's the right default for small apps. But there's a point —
maybe 20, 30, 40 components in — where the trade-off flips.

components/ becomes a junk drawer. A "workout" change touches
WorkoutActiveMode.vue, useWorkoutMode.ts, and workout.ts — three folders.

And this matters for agents too. The agent greps across the whole tree to
figure out what relates to what. Most of what it pulls is noise.

TRANSITION: Feature-sliced flips this.
-->

---
layout: center
class: 'text-center'
---

# Feature-sliced flips it

<div class="text-lg op-80 mt-6">
Group by what files <span style="color: #ff6bed">do</span>, not by what they are.
</div>

<!--
Same files. Different addressing. Instead of components/ + composables/ +
stores/ at the top level, the top level becomes the features themselves:
workout/, timers/, exercises/.

Each feature owns its components, its composables, its store. You stop asking
"where do components live" and start asking "where does the workout feature
live."

TRANSITION: Watch the regroup happen.
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
📁 src/
├── 📁 components/
│   ├── 🏋️ WorkoutActiveMode.vue    → workout
│   ├── 🏋️ WorkoutHeader.vue        → workout
│   ├── ⏱️ TimerDisplay.vue         → timers
│   ├── 💪 ExerciseList.vue         → exercises
│   └── ⚙️ SettingsForm.vue         → settings
├── 📁 composables/
│   ├── 🏋️ useWorkoutMode.ts        → workout
│   ├── ⏱️ useRestTimer.ts          → timers
│   ├── 💪 useExercises.ts          → exercises
│   └── ⚙️ useSettings.ts           → settings
└── 📁 stores/
    ├── 🏋️ workout.ts               → workout
    ├── ⏱️ timers.ts                → timers
    └── ⚙️ settings.ts              → settings
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
│   ├── 📁 components/
│   │   └── 💪 ExerciseList.vue
│   └── 📁 composables/
│       └── 💪 useExercises.ts
└── 📁 settings/
    ├── 📁 components/
    │   └── ⚙️ SettingsForm.vue
    ├── 📁 composables/
    │   └── ⚙️ useSettings.ts
    └── ⚙️ store.ts
```
````

<!--
[click] State 1 — typical mid-size Vue app. Components, composables, stores.
Grouped by what files ARE, not what they DO. A change to "workout" touches three
folders.

[click] State 2 — same files, annotated with the feature each belongs to. Four
features mixed across three buckets. The agent greps across folders to find
anything related to one thing.

[click] State 3 — I just regrouped. Same files. Same code. workout/ is one
folder. timers/ is one folder. The agent finds everything by name. So do you.

TRANSITION: Let me show you what that does to the agent.
-->

---

# What the agent sees

<div class="text-center text-sm op-60 mb-6">Same prompt: <em>"Add a streak counter to the active workout"</em></div>

<div class="grid grid-cols-2 gap-6">

<div>

<div class="text-xs op-50 mb-2">FLAT: agent greps across folders</div>

<div class="space-y-1 text-sm font-mono">
<div><span class="text-red-400">✗</span> components/SettingsForm.vue</div>
<div><span class="text-green-400">✓</span> components/WorkoutActiveMode.vue</div>
<div><span class="text-green-400">✓</span> components/WorkoutHeader.vue</div>
<div><span class="text-red-400">✗</span> components/TimerDisplay.vue</div>
<div><span class="text-red-400">✗</span> composables/useSettings.ts</div>
<div><span class="text-green-400">✓</span> composables/useWorkoutMode.ts</div>
<div><span class="text-red-400">✗</span> stores/timers.ts</div>
</div>

<div class="mt-4 text-xs op-70"><strong style="color: #ff6bed">~40% relevant.</strong> The rest crowds the window.</div>

</div>

<div>

<div class="text-xs op-50 mb-2">FEATURE: agent <code>ls features/workout/</code></div>

<div class="space-y-1 text-sm font-mono">
<div><span class="text-green-400">✓</span> workout/components/WorkoutActiveMode.vue</div>
<div><span class="text-green-400">✓</span> workout/components/WorkoutHeader.vue</div>
<div><span class="text-green-400">✓</span> workout/composables/useWorkoutMode.ts</div>
<div><span class="text-green-400">✓</span> workout/store.ts</div>
</div>

<div class="mt-4 text-xs"><strong style="color: #ff6bed">100% relevant.</strong> One folder is the answer.</div>

</div>

</div>

<!--
The folder structure is the agent's first read.

LEFT — flat layout, "streak counter on the workout" sends the agent scanning
components/ and composables/. Most of what it pulls is unrelated — SettingsForm,
TimerDisplay, useSettings. The window fills with noise it has to think past.

RIGHT — feature layout, "workout" maps to features/workout/. The agent lists
one folder and gets exactly the files that matter. No grep. No guess. Same
outcome as a good AGENTS.md — a narrow window into the right code, so tokens go
to output instead of search. And the change stays local, so I stop being scared
of it.

TRANSITION: That was the toy. Here's the real src/features/.
-->

---

# Not a toy: 10 real feature slices

<div class="text-center text-sm op-60 mb-4">The actual <code>src/features/</code> of the workout tracker — same pattern, production scale.</div>

<div class="grid grid-cols-2 gap-8 items-center max-w-4xl mx-auto">

```text
src/features/
├── workout/           34 files
├── benchmarks/        30
├── settings/          25
├── onboarding/        16
├── exercises/          9
├── weight/             7
├── progressions/       7
├── timers/             6
├── templates/          6
└── log-past-workout/   5
```

<div class="space-y-3">
<Card glow size="sm"><div class="text-sm">Each slice owns its <code>components/</code>, <code>composables/</code>, <code>utils/</code>.</div></Card>
<Card variant="muted" size="sm"><div class="text-sm">No <code>store.ts</code>, no Pinia — state is Dexie (IndexedDB) + composables.</div></Card>
<Card variant="muted" size="sm"><div class="text-sm">"Add a streak counter to the workout" → the agent opens <strong style="color:#ff6bed">one</strong> of these folders.</div></Card>
</div>

</div>

<!--
The four-feature diagram was the teaching device. This is the real thing — ten
feature slices in the app the talk is about. The workout slice alone is 34
files: components, composables, utils.

Two honest notes. No store.ts and no Pinia — state lives in Dexie / IndexedDB
behind a db provider, plus composables. And no index.ts barrels; boundaries are
enforced a different way — the next slide.

Same payoff as the toy, at scale: any feature request maps to one folder, so the
agent reads one folder.

TRANSITION: But folders alone won't keep the agent honest. You need rules.
-->

---
transition: fade-out
---

<TalkFramedImage src="/who-can-import-what.png" contain />

<!--
Three rules. That's it.

ONE — arrows only point down. lib can't import hooks. components can't import
features. The layer order is fixed.

TWO — inside features/, siblings can't see each other. cart cannot import
checkout. If they share something, the shared thing belongs in lib or
components, not in one feature reaching into another.

THREE — app/ is the only place that sees the whole graph. That's where wiring
happens — routes, providers, the shell.

If you can keep these three rules in your head, the codebase stays navigable.
But you won't — and the agent definitely won't. So you enforce it: the real app
uses import-x/no-restricted-paths with seven cross-feature zones. Structure,
enforced.

TRANSITION: And a lint rule is only one net. You can make the boundary runnable.
-->

---

# Boundaries as a test that fails the build

<div class="grid grid-cols-2 gap-6 mt-4">

<div>
<div class="text-xs op-50 mb-2"><code>src/__tests__/architecture/architecture.test.ts</code></div>

```ts
import { projectFiles } from 'archunit'

for (const feature of FEATURES) {
  it(`${feature} can't import other features`, async () => {
    for (const other of FEATURES.filter(f => f !== feature)) {
      await expect(
        projectFiles().inFolder(`src/features/${feature}/**`)
          .shouldNot().dependOnFiles()
          .inFolder(`src/features/${other}/**`)
      ).toPassAsync()
    }
  })
}
```

</div>

<div class="flex flex-col gap-3 justify-center">
<Card glow size="sm"><div class="text-sm">Two nets: <code>import-x/no-restricted-paths</code> in ESLint <em>and</em> <strong>archunit</strong> tests.</div></Card>
<Card variant="muted" size="sm"><div class="text-sm">The agent can <em>run</em> the boundary — chase it to green like any test.</div></Card>
<Card variant="muted" size="sm"><div class="text-sm op-90">Honest gap: 7 of 10 slices are guarded. <code>onboarding</code>, <code>progressions</code>, <code>weight</code> drifted out — a real "fix the factory" todo.</div></Card>
</div>

</div>

<!--
The three import rules aren't just a diagram — they're enforced twice. ESLint's
import-x no-restricted-paths at lint time, and this archunit test at test time.
The nice part: the agent can RUN the architecture, not just read it — feature
isolation becomes a test it chases to green.

And an honest moment, because this is the real repo: the guards drifted. Ten
slices ship, but only seven are in the lint zones and eight in this test —
onboarding, progressions, weight slipped through. That's not embarrassing,
that's the whole point of the next act: when a guard drifts, you don't patch the
PR, you fix the factory.

TRANSITION: That's the three buckets. Let me tie them together.
-->

---
clicks: 3
transition: fade-out
---

# The three buckets compound

<v-clicks>

- **Context** — AGENTS.md, skills, hooks, brain/ keep the window tight
- **Feedback** — 15 layers + the agent as a user keep it honest
- **Discoverability** — vertical slices keep it local

</v-clicks>

<!--
[pause]

CLICK 1 — Context. AGENTS.md, skills, hooks, brain/. Without it, every other
          move leaks tokens every session.
CLICK 2 — Feedback. 15 layers of automated checks plus agent-browser as the
          sixteenth. Signals the agent can chase to green on its own.
CLICK 3 — Discoverability. Vertical slices instead of horizontal layers. The
          agent stays in one folder, the window stays full of relevant code.

Same three words as the pyramid. That's the toolkit — and it fixed both my
problems at once.

TRANSITION: Now — where is this heading?
-->

---
transition: fade
---

<PartSlide
  icon="→"
  title="Where this is heading"
  subtitle="The software factory"
/>

<!--
[breathe] [scan room]

Last act. The bigger picture — back to thread one, the general workflow. Once
the codebase is built for the agent, the role itself changes.

TRANSITION: And the line that snapped this into focus was a tweet from Peter
Steinberger.
-->

---
layout: statement
transition: fade-out
---

# Stop prompting agents?

<div class="flex justify-center mt-8">
  <img src="/peter-steinberger-loop-tweet.png" alt="Peter Steinberger tweet about designing loops that prompt coding agents" class="w-[88%] rounded-xl shadow-2xl" />
</div>

<div class="absolute bottom-4 right-8 text-xs op-40">x.com/steipete/status/2063697162748260627</div>

<!--
[pause]

This is the tweet that kicked off the loop-engineering conversation a few weeks
ago. Peter Steinberger put the shift into one sentence: stop hand-feeding the
agent every step. Design the thing that prompts it for you.

Not because prompts don't matter. Because prompts are now too small a unit of
work.

TRANSITION: So what does that actually mean in a codebase?
-->

---
clicks: 4
transition: fade-out
---

# What that actually means

<div class="text-center text-sm op-60 -mt-2 mb-2">One idea: loop engineering — climb from one ask to a loop that runs without you.</div>

<div class="grid grid-cols-5 gap-3 mt-12 items-center text-center">

<div>
<div class="text-xs op-50 mb-2">One ask</div>
<div class="text-xl font-bold">Prompt</div>
</div>

<div v-click>
<div class="text-xs op-50 mb-2">Reusable ask</div>
<div class="text-xl font-bold" style="color:#ff6bed">Skill</div>
</div>

<div v-click>
<div class="text-xs op-50 mb-2">Ask again</div>
<div class="text-xl font-bold" style="color:#ff6bed">Loop</div>
</div>

<div v-click>
<div class="text-xs op-50 mb-2">Finish line</div>
<div class="text-xl font-bold" style="color:#ff6bed">Goal</div>
</div>

<div v-click>
<div class="text-xs op-50 mb-2">Wake itself</div>
<div class="text-xl font-bold" style="color:#ff6bed">Automation</div>
</div>

</div>

<div v-after class="text-center text-xl op-75 mt-14 max-w-4xl mx-auto">
Prompt engineering perfects one message.<br/>
<strong style="color:#ff6bed">Loop engineering designs the loop that sends them for you.</strong>
</div>

<!--
Here's the practical meaning — and this is one idea: loop engineering.

One prompt is one request.
CLICK — A skill is the reusable version of that request.
CLICK — A loop runs the work-check-fix cycle without me typing "continue."
CLICK — A goal gives the loop a finish line: keep going until this is true.
CLICK — An automation wakes the loop up on a schedule or when something changes.

Notice the direction: every rung removes me from a step. By the top, I'm not
prompting the agent — I've designed the loop that prompts it for me. That's the
whole shift. Prompt engineering perfects one message; loop engineering builds the
thing that sends them.

(The factory comes later — that's a different idea. Loops are one part of it.)

TRANSITION: In the product, this starts looking less like chat and more like
an operating surface.
-->

---
transition: fade-out
---

# Loop engineering becomes an interface

<div class="mt-6">
  <TalkFramedImage src="/afk/routine-new-routine.png" alt="New routine screen for an agent loop with repository context, trigger options, connectors, behavior, notifications, and permissions" contain :shadow="false" />
</div>

<!--
This is the shift made visible.

Not "please remember to do this every week." A routine has a name, instructions,
a repo, a trigger, connectors, behavior, notifications, permissions.

That is loop engineering. You are designing the environment that will prompt
the agent later, with the right context and the right boundaries already wired
in.

TRANSITION: And the prompt behind it can be very concrete.
-->

---
transition: fade-out
---

# This could be the prompt

```md {maxHeight:'390px'}
You are the maintainer of the "brain" knowledge folder for the workout
tracking app located at projects/active/<APP_NAME>.

The brain folder lives at projects/active/<APP_NAME>/brain and holds
markdown notes documenting the app's architecture, data models, features,
conventions, and past decisions. Your single job each run: keep the brain
in sync with what the code actually does right now.

## Step 1 — Inventory
List every file under projects/active/<APP_NAME>/brain. Build a quick map
of the current codebase under projects/active/<APP_NAME> (source files,
schema/migrations, config, routes, components).

## Step 2 — Dispatch subagents IN PARALLEL
Group the brain files into independent batches (by topic or folder).
Launch one subagent per batch concurrently. Give each subagent ONLY its
assigned brain files plus read access to the codebase. Each subagent must:
  - Read its assigned brain note(s).
  - Cross-reference every factual claim against the current code.
  - Classify each note (or section) as one of:
      CURRENT  — accurate, leave untouched.
      STALE    — partially wrong; rewrite the affected sections to match
                 the code as it exists now.
      OBSOLETE — describes features, files, functions, or models that no
                 longer exist or were renamed beyond recognition.
  - Return a structured report: file path, classification, exact edits to
    apply, and a one-line reason for anything marked OBSOLETE.

## Step 3 — Apply changes
  - STALE files: apply the rewrites.
  - OBSOLETE files: move them to projects/active/<APP_NAME>/brain/_archive/
    (do NOT hard-delete) and note the reason in the PR body.
  - If a note is mostly current but has one dead section, edit in place
    rather than archiving the whole file.

## Step 4 — Open a PR (do not push to main)
Commit to a branch named brain-sync/<YYYY-MM-DD>. Open a PR titled
"Brain sync: <short summary>" whose body lists, in three sections:
  - Updated (with a one-line diff summary per file)
  - Archived/removed (with the reason)
  - Reviewed, no change needed
If nothing changed, do not open a PR — just stop.

## What "outdated" means
Treat a note as stale/obsolete when it references: removed or renamed
functions, components, routes, or DB columns; a data model that no longer
matches the schema/migrations; libraries or config no longer present;
or workflows the code no longer supports. When unsure, mark STALE and
propose a conservative edit rather than deleting.
```

<!--
This is not magic. This could literally be the routine prompt.

It says what folder owns the knowledge, what "correct" means, how to split the
work, when to use parallel subagents, what to edit, what to archive, and when to
stop without opening a PR.

That is the whole pattern: encode the maintenance loop once, then let the system
wake it up.

TRANSITION: And when it wakes up, it looks like this.
-->

---
transition: fade-out
---

# This is how it could look

<div class="mt-7">
  <TalkFramedImage src="/afk/routine-run-brain-sync.png" alt="Running routine for an updated docs loop, showing command batches, parallel checks, subagents, and a scheduled run panel" contain :shadow="false" />
</div>

<!--
This is the loop actually running.

Scheduled check-in. It inventories the repo. It reads the brain folder. It fans
out into parallel work. It has running tasks. And on the side, the routine has a
run history.

The point is not that the UI is fancy. The point is that the maintenance loop is
now operational. It is something the project can run, not something I have to
remember to ask for.

TRANSITION: And if it finds real drift, the output is a PR.
-->

---
transition: fade-out
---

# It opens the PR for review

<div class="mt-6">
  <TalkFramedImage src="/afk/brain-sync-pr.png" alt="GitHub pull request opened by the brain sync routine, showing updated agent docs, checks, files changed, and able to merge status" contain :shadow="false" />
</div>

<!--
This is the payoff.

The loop did not just print a wall of text somewhere. It made the changes, put
them on a branch, opened a PR, and gave me the summary in the exact shape I asked
for: updated, archived or removed, reviewed with no change.

Human back at the edge: I review the PR. The factory did the babysitting.

TRANSITION: And that means the agent itself is not the interesting part.
-->

---
layout: statement
transition: fade-out
---

# The agent is not the factory.

<v-click>

# The factory is everything around it.

</v-click>

<div v-after class="grid grid-cols-5 gap-4 max-w-5xl mx-auto mt-10 text-left">
  <Card variant="muted" size="sm"><div class="text-sm">Context<br/><span class="op-60">AGENTS.md, docs, skills, brain/</span></div></Card>
  <Card variant="muted" size="sm"><div class="text-sm">Tools<br/><span class="op-60">CLI, browser, Sentry, MCP</span></div></Card>
  <Card variant="muted" size="sm"><div class="text-sm">Feedback<br/><span class="op-60">types, lint, tests, QA</span></div></Card>
  <Card variant="muted" size="sm"><div class="text-sm">Gates<br/><span class="op-60">worktrees, review, approvals</span></div></Card>
  <Card variant="muted" size="sm"><div class="text-sm" style="color:#ff6bed">Loops<br/><span class="op-60">skills, goals, automations</span></div></Card>
</div>

<div v-after class="text-center text-lg op-75 mt-8 max-w-4xl mx-auto">
<strong style="color:#ff6bed">Factory engineering optimizes every future conversation.</strong>
</div>

<!--
[pause]

CLICK — The model is the worker. The factory is everything around it: context,
tools, tests, browser QA, hooks, worktrees, Sentry, docs, review gates — and the
loops we just built. The loops are one part of the factory, not the whole thing.

That's the second idea, and it's bigger than loop engineering. A single loop runs
without me. The factory makes the whole repo better every time a loop runs —
that's why factory engineering optimizes every future conversation, not just the
next one.

So when the agent fails, the question is not only "what prompt should I have
written?" The better question is: what part of the factory allowed this mistake?

TRANSITION: For my workout tracker, that becomes very concrete.
-->

---
transition: fade-out
---

# The workout tracker factory

<div class="text-center text-sm op-60 -mt-2 mb-6">Not one big agent. Four small loops that make the repo safer over time.</div>

<TalkCardGrid
  :columns="2"
  compact
  max-width="max-w-5xl"
  :cards="[
    { title: 'Docs loop', body: 'After a session, extract durable learnings: domain rules, architecture decisions, agent mistakes.' },
    { title: 'Sentry loop', body: 'Read production errors, group duplicates, find likely files, propose the smallest safe fix.' },
    { title: 'Architecture loop', body: 'Once a week, find one refactor that makes future agent work easier and safer.' },
    { title: 'PR babysitter', body: 'Watch CI and review comments, draft low-risk fixes in a worktree, never merge.' },
  ]"
/>

<div class="text-center text-lg mt-8 op-80">
The loop is not "build an app." It is <strong style="color:#ff6bed">find a weak spot → improve the factory → hand me a PR.</strong>
</div>

<!--
This is where the idea gets real. The workout tracker is not huge, but it has
real product state: active workouts, rest timers, history, offline persistence,
mobile UX. Prompting alone stops feeling safe.

So I don't want one giant magic agent. I want small recurring loops.

Docs loop — every session teaches the next one. Sentry loop — production errors
turn into prepared repair tickets. Architecture loop — the repo gets easier for
agents every week. PR babysitter — CI and review comments stop becoming my
full-time job.

For the workout tracker, the loop is not "build an app." The loop is: find a
weak spot, improve the factory, produce a reviewable PR.

TRANSITION: And that does not mean removing the human.
-->

---
layout: statement
transition: fade-out
---

# The point is not no humans.

<v-click>

# I still make product decisions.

</v-click>

<v-click>

# The factory removes babysitting.

</v-click>

<!--
[pause]

This is the part I want to be very clear about.

CLICK — I still decide what product should exist. I still read the PR. I still
own the quality of what ships.

CLICK — The goal is not to remove me from engineering. The goal is to remove me
from babysitting. Reading Sentry manually. Re-running CI. Remembering to update
docs. Asking the agent to continue. That is the work the factory can absorb.

Now AFK coding makes sense: spec in, agent execution in the middle, human review
at the edge.

TRANSITION: AFK coding is already here.
-->

---
layout: statement
transition: fade-out
---

# AFK coding is already here.

<v-click>

# You write the spec. The agent ships the PR. You review.

</v-click>

<!--
[pause]

AFK — away from keyboard. You write a spec. Kick off an agent. Walk away. Come
back to a draft PR. The agent ran tests, hit a failure, fixed itself, ran again,
opened the PR with a summary. You review.

CLICK — The work is no longer "me typing." The work is "me deciding what should
exist, and reviewing what came back."

TRANSITION: Here's what the loop looks like in practice.
-->

---
layout: image
image: /afk/pipeline.png
backgroundSize: contain
---

<!--
Six phases. HITL at the edges. AFK in the middle.

Spec — I align with the business. Human in the loop.
Slice — agent breaks the PRD into vertical sub-tickets.
Ralph loop — one agent per slice, fresh context every iteration, TDD inside.
Refactor — a dedicated pass. The step LLMs always skip.
QA — a QA agent drives the real browser.
Review — I read the PR. HITL again.

Human judgment at the edges. Agent execution in the middle. Full write-up on my
blog if you want the long version.

TRANSITION: The most important thing in this loop is what I do when it goes wrong.
-->

---
layout: statement
transition: fade-out
---

# Agent did it wrong?

# Fix the factory, not the PR.

<!--
[pause]

Here's the part most people miss. The agent ships a bug. The instinct is: fix
the bug, merge, move on.

CLICK — The instinct is wrong. Fix the FACTORY.

CLICK — A bug isn't a bug. It's a factory defect.

Add an ESLint rule that catches that whole class of mistake. Update AGENTS.md so
the convention is written down. Tighten the slash command or the prompt if
that's where it leaked.

The PR fix is one bug. The factory fix prevents the next hundred. This is the
same compounding loop as the three buckets — every PR review teaches the
factory. The codebase gets smarter over time. You get more leverage every week.

TRANSITION: Here's what a real factory fix looks like.
-->

---

# A real factory fix

<div class="text-center text-sm op-60 mb-4">The agent kept forgetting to wrap data calls. So I made it impossible.</div>

```ts
// eslint-local-rules/repository-trycatch.ts
AwaitExpression(node) {
  if (!isRepoMethodCall(node.argument)) return   // get*Repository().method()
  if (isWrappedInTryCatch(context, node)) return
  context.report({ node, messageId: 'missingTryCatch' })
}
// message: "Repository calls must be wrapped with tryCatch().
//           const [error, result] = await tryCatch(<call>)"
```

<div class="text-center text-lg mt-6 op-80">
One bug → one rule → that whole class of mistake <strong style="color:#ff6bed">can never ship again.</strong>
</div>

<!--
"Fix the factory" as a real artifact, not a slogan.

The agent kept calling the repository layer without my Result-style error
handling — await getWorkoutRepository().findAll() with no tryCatch. I could fix
each PR forever. Instead I wrote a ~40-line ESLint rule: any await of a
get*Repository().method() that isn't wrapped in tryCatch fails the build, with a
message telling the agent exactly what to write.

The PR fix is one bug. This is the factory fix — one of five custom rules I built
exactly this way. The codebase teaches the next agent.

TRANSITION: And this is not locked to one stack or one tool.
-->

---
layout: statement
transition: fade
---

# Same stack. Any tool.

<div class="text-xl op-70 mt-8">
React, a Node backend, Go — the agent needs the same three things everywhere.
And none of it is locked to Claude Code.
</div>

<div class="grid grid-cols-2 gap-6 max-w-4xl mx-auto mt-10 text-left">

<v-click>

<Card variant="muted" size="sm">
<div class="text-xs op-50 mb-2">Open formats</div>
<div class="text-sm leading-relaxed">
<code>AGENTS.md</code> · <code>SKILL.md</code><br>
<span class="op-60">Write the recipe once.</span>
</div>
</Card>

</v-click>

<v-click>

<Card variant="muted" size="sm">
<div class="text-xs op-50 mb-2">Who reads them</div>
<div class="text-sm leading-relaxed">
Claude Code · <span style="color: #ff6bed">VS Code Copilot</span> · Cursor · Codex<br>
<span class="op-60">~30 agents, same files.</span>
</div>
</Card>

</v-click>

</div>

<v-click>

<div class="text-base op-70 mt-8 max-w-3xl mx-auto">
Copilot now ships <span style="color: #ff6bed">custom agents with restricted tools</span>, <span style="color: #ff6bed">subagents</span>, and <span style="color: #ff6bed">skills</span> natively — the exact patterns from this talk.
</div>

</v-click>

<div class="absolute bottom-4 right-8 text-xs op-40">alexop.dev/posts/whats-new-vscode-copilot-january-2026</div>

<!--
I used Vue and Nuxt because that's my world, but nothing here is Vue-specific.
Context, feedback, discoverability — an agent needs the same three things in any
codebase: React, a Node backend, Go.

CLICK — and here's the part that matters for the next three years. None of this
is bet on a single tool. AGENTS.md, SKILL.md — those are open formats.

CLICK — write your AGENTS.md and SKILL.md once and roughly thirty agents read
them. Claude Code, Copilot, Cursor, Codex. I run Copilot workshops, and I
watched it grow up: this January Copilot shipped custom agents with restricted
tool lists, subagents, and skills on by default — natively. If you've used
Claude Code's subagents, you'll recognize this exactly.

CLICK — so don't bet on a tool. Bet on the patterns. The stack you build for the
agent is portable, and it's the engineering seniors have fought for for twenty
years. What's good for a human team is good for an agent — it just pays off twice
now, on every tool.

TRANSITION: And the vendors aren't slowing down. Look what dropped last week.
-->

---
transition: fade
---

# Last week: tag @Claude in Slack

<div class="mt-4">
  <TalkFramedImage src="/claude-tag/announcement-hero.png" alt="Anthropic announcement: Introducing Claude Tag, dated Jun 23 2026, with an @Claude banner over a photo of a team" :contain="false" maxHeight="56vh" :shadow="false" />
</div>

<div class="text-base op-70 mt-4 text-center max-w-3xl mx-auto">
Give it a channel, wire up your tools and codebase — then <span style="color: #ff6bed">delegate and walk away</span>. Claude joins as a teammate that works async and remembers the channel.
</div>

<div class="absolute bottom-4 right-8 text-xs op-40">anthropic.com/news/introducing-claude-tag</div>

<!--
Quick one before I close. This dropped last week — Claude Tag.

It's not a new chat window. You grant Claude a Slack channel, connect it to your
tools and your codebase, and then anyone on the team can tag @Claude, hand it a
task, and walk away. It works asynchronously and it remembers the channel — so
you stop re-explaining context every time.

Notice the shape: it's the exact AFK loop from this talk, just moved into the
place your team already lives.

TRANSITION: And this isn't a demo reel. Look how they actually use it.
-->

---
transition: fade
---

# This isn't a demo. It's how they ship.

<div class="h-full flex flex-col items-center justify-center -mt-12">

<div class="text-8xl font-bold" style="color: #ff6bed">65%</div>

<div class="mt-4 text-lg op-70">of Anthropic's product-team code now ships by tagging <span style="color: #ff6bed">@Claude</span></div>

<div class="mt-10 max-w-2xl text-center text-sm op-60">
Started in engineering — now spreading to chasing product metrics, working support tickets, and hunting the root cause of tricky bugs.
</div>

</div>

<div class="absolute bottom-4 right-8 text-xs op-40">anthropic.com/news/introducing-claude-tag</div>

<!--
And here's the number that made me put this slide in. Sixty-five percent of
their product team's code now comes through tagging @Claude. That's not a side
experiment — that's the main way the work gets done.

And it's leaking out of engineering: product folks tag it to chase metrics,
support tags it on tickets, people tag it to find the root cause of a nasty bug.
That's a software factory running across a whole company, not one developer at a
terminal.

TRANSITION: Pull back, and you see every vendor doing the same thing.
-->

---
layout: statement
transition: fade
---

# The tools keep moving toward the factory.

<div class="grid grid-cols-3 gap-6 max-w-4xl mx-auto mt-10 text-left">

<v-click>

<Card variant="muted" size="sm">
<div class="text-xs op-50 mb-2">2023</div>
<div class="text-sm leading-relaxed">A chat box.<br><span class="op-60">You paste, it answers.</span></div>
</Card>

</v-click>

<v-click>

<Card variant="muted" size="sm">
<div class="text-xs op-50 mb-2">2025</div>
<div class="text-sm leading-relaxed">An agent in your repo.<br><span class="op-60">Loops, tools, subagents.</span></div>
</Card>

</v-click>

<v-click>

<Card variant="muted" size="sm">
<div class="text-xs op-50 mb-2">2026</div>
<div class="text-sm leading-relaxed">A teammate you <span style="color: #ff6bed">@-mention</span>.<br><span class="op-60">Async, proactive, shared.</span></div>
</Card>

</v-click>

</div>

<v-click>

<div class="text-base op-70 mt-8 max-w-3xl mx-auto">
You don't control that roadmap. But every step on it assumes the same thing — <span style="color: #ff6bed">a project an agent can actually work in</span>.
</div>

</v-click>

<!--
Zoom out and the trend is one direction. 2023, it was a chat box you pasted into.
2025, an agent living in your repo — loops, tools, subagents, the stuff most of
this talk was about. 2026, a teammate you @-mention in Slack that runs async.

CLICK, CLICK, CLICK through the three.

CLICK — and here's why I care more about this than any single feature. You don't
control that roadmap; the vendors do, and they're shipping fast. But every one of
those steps quietly assumes the same thing underneath: a project an agent can
actually work in. The context, the feedback loops, the discoverability. Get that
right and you're ready for whatever ships next.

TRANSITION: Which is the real point of this whole talk.
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

<v-click>

<div class="text-xl op-70 mt-8 max-w-3xl mx-auto">Remember the levels at the start? Most hands were L1–L2. Context, Feedback, Discoverability are how you move <strong style="color: #ff6bed">one to the right</strong> — you move yourself.</div>

</v-click>

<!--
Get the project right — context, feedback, discoverability — and you stop
writing code by hand. Not because you type less, but because the agent can
finally do the work, and you can finally trust it.

CLICK — and the callback to where we started: most hands went up at L1 and L2.
The three buckets are exactly how you move yourself one level to the right. Not
the tool moving you — you, moving you.

And one confession: this whole talk was framed around AI — but none of it is
new. Testing, TDD, feature-based architecture, strict types, small components.
The things senior engineers have fought for in code review for twenty years.
There was never a separate "AI-ready" checklist. There was just good
engineering — and now it pays off twice.

TRANSITION: So before you go — one thing.
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
