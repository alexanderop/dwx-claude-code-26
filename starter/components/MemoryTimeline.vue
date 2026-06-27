<script setup lang="ts">
const props = withDefaults(defineProps<{ step?: number }>(), { step: 0 })

// 4 memory types revealed left-to-right along a session timeline.
// step 0: Working only (the chatbot). 1: +Semantic. 2: +Procedural. 3: +Episodic + loop.
const MEMORIES = [
  {
    n: 0,
    x: 24,
    kind: 'Working',
    sub: 'the context window',
    map: '/context · /clear · /compact',
    when: 'every turn',
    detail: 'Keep it lean — progressive disclosure',
  },
  {
    n: 1,
    x: 240,
    kind: 'Semantic',
    sub: 'stable facts',
    map: 'AGENTS.md + docs/',
    when: 'session start',
    detail: 'Loaded fresh every session',
  },
  {
    n: 2,
    x: 456,
    kind: 'Procedural',
    sub: 'how-to',
    map: 'Skills',
    when: 'on match',
    detail: 'Repeatable workflows, loaded when relevant',
  },
  {
    n: 3,
    x: 672,
    kind: 'Episodic',
    sub: 'lived experience',
    map: 'brain/ + auto memory',
    when: 'across sessions',
    detail: 'Lessons distilled, written back',
  },
] as const

function stateFor(n: number) {
  if (props.step < n) return 'hidden'
  if (props.step === n) return 'active'
  return 'shown'
}
</script>

<template>
  <div class="memory-timeline" :data-step="props.step">
    <svg
      viewBox="0 0 900 470"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="Four kinds of agent memory along a session timeline: Working (every turn), Semantic (session start), Procedural (on match), Episodic (across sessions)"
    >
      <defs>
        <marker id="mt-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
          <path d="M0,0 L10,5 L0,10 z" fill="rgba(234,237,243,0.55)" />
        </marker>
        <marker id="mt-arrow-pink" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
          <path d="M0,0 L10,5 L0,10 z" fill="#ff6bed" />
        </marker>
        <linearGradient id="mt-card-fill" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="rgba(255,107,237,0.10)" />
          <stop offset="100%" stop-color="rgba(52,63,96,0.42)" />
        </linearGradient>
        <linearGradient id="mt-axis" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0%" stop-color="rgba(255,107,237,0.7)" />
          <stop offset="100%" stop-color="rgba(234,237,243,0.25)" />
        </linearGradient>
        <filter id="mt-glow" x="-40%" y="-40%" width="180%" height="180%">
          <feGaussianBlur stdDeviation="5" result="b" />
          <feMerge>
            <feMergeNode in="b" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <!-- timeline axis -->
      <g>
        <line x1="24" y1="92" x2="858" y2="92" stroke="url(#mt-axis)" stroke-width="2" marker-end="url(#mt-arrow)" />
        <text x="24" y="74" class="xs muted phase">SESSION START</text>
        <text x="441" y="74" text-anchor="middle" class="xs muted phase">DURING SESSION</text>
        <text x="858" y="74" text-anchor="end" class="xs muted phase">SESSION END →</text>
      </g>

      <!-- memory cards -->
      <g v-for="m in MEMORIES" :key="m.n" :class="['mt-item', stateFor(m.n)]">
        <!-- tick on the axis -->
        <circle :cx="m.x + 102" cy="92" r="5" class="tick" />
        <line :x1="m.x + 102" y1="97" :x2="m.x + 102" y2="124" class="tick-line" />

        <!-- when badge -->
        <g :transform="`translate(${m.x + 48}, 132)`">
          <rect width="108" height="22" rx="11" class="when-pill" />
          <text x="54" y="15" text-anchor="middle" class="xs bold when-text">{{ m.when }}</text>
        </g>

        <!-- card -->
        <g :transform="`translate(${m.x}, 168)`" :filter="stateFor(m.n) === 'active' ? 'url(#mt-glow)' : undefined">
          <rect width="204" height="186" rx="14" class="card-bg" />
          <text x="20" y="34" class="md bold accent">{{ m.kind }}</text>
          <text x="20" y="56" class="sm muted">{{ m.sub }}</text>
          <line x1="20" y1="74" x2="184" y2="74" class="divider" />
          <text x="20" y="104" class="mono map">{{ m.map }}</text>
          <foreignObject x="20" y="118" width="166" height="58">
            <div xmlns="http://www.w3.org/1999/xhtml" class="detail">{{ m.detail }}</div>
          </foreignObject>
        </g>
      </g>

      <!-- chatbot bracket around Working (fades once we move past it) -->
      <g :class="['mt-chatbot', props.step >= 1 ? 'shown' : 'active']">
        <rect x="14" y="120" width="224" height="244" rx="18" class="chatbot-box" />
        <g transform="translate(126, 380)">
          <text text-anchor="middle" class="sm muted">a chatbot stops here</text>
        </g>
      </g>

      <!-- episodic loop-back: feeds the next session -->
      <g :class="['mt-loop', props.step >= 3 ? 'active' : 'hidden']">
        <path
          d="M 774 168 C 774 30 360 18 126 18 C 70 18 24 40 24 86"
          fill="none"
          stroke="#ff6bed"
          stroke-width="2"
          stroke-dasharray="5 4"
          marker-end="url(#mt-arrow-pink)"
        />
        <g transform="translate(400, 6)">
          <rect width="120" height="22" rx="11" class="loop-pill" />
          <text x="60" y="15" text-anchor="middle" class="xs bold loop-text">feeds next session</text>
        </g>
      </g>

      <!-- punchline -->
      <g :class="['mt-punch', props.step >= 3 ? 'active' : 'hidden']" transform="translate(450, 432)">
        <text text-anchor="middle" class="lg">
          <tspan class="muted">A chatbot has working memory. A coding agent needs </tspan><tspan class="accent bold">all four.</tspan>
        </text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.memory-timeline {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}
.memory-timeline svg {
  width: 100%;
  max-width: 100%;
  max-height: 100%;
  height: auto;
}

.memory-timeline :deep(text) {
  font-family: Geist, ui-sans-serif, system-ui, sans-serif;
  font-size: 14px;
  font-weight: 400;
  line-height: 1;
  fill: #eaedf3;
}
.memory-timeline :deep(.xs) { font-size: 11px; }
.memory-timeline :deep(.sm) { font-size: 12px; }
.memory-timeline :deep(.md) { font-size: 15px; }
.memory-timeline :deep(.lg) { font-size: 18px; }
.memory-timeline :deep(.bold) { font-weight: 700; }
.memory-timeline :deep(.muted) { opacity: 0.6; }
.memory-timeline :deep(.accent) { fill: #ff6bed; }
.memory-timeline :deep(.phase) { letter-spacing: 1.5px; font-weight: 600; }
.memory-timeline :deep(.mono) {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 12px;
}

.memory-timeline :deep(.card-bg) {
  fill: url(#mt-card-fill);
  stroke: rgba(255, 107, 237, 0.28);
  stroke-width: 1;
}
.memory-timeline :deep(.divider) { stroke: rgba(234, 237, 243, 0.12); stroke-width: 1; }
.memory-timeline :deep(.map) { fill: #ff6bed; opacity: 0.92; }
.memory-timeline :deep(.detail) {
  font-family: Geist, ui-sans-serif, system-ui, sans-serif;
  font-size: 11.5px;
  line-height: 1.35;
  color: rgba(234, 237, 243, 0.72);
}

.memory-timeline :deep(.tick) { fill: #ff6bed; }
.memory-timeline :deep(.tick-line) { stroke: rgba(255, 107, 237, 0.45); stroke-width: 1.5; }

.memory-timeline :deep(.when-pill) {
  fill: rgba(255, 107, 237, 0.12);
  stroke: rgba(255, 107, 237, 0.4);
  stroke-width: 1;
}
.memory-timeline :deep(.when-text) { fill: #ff9bf2; }

.memory-timeline :deep(.chatbot-box) {
  fill: none;
  stroke: rgba(234, 237, 243, 0.35);
  stroke-width: 1.4;
  stroke-dasharray: 6 4;
}
.memory-timeline :deep(.loop-pill) {
  fill: rgba(255, 107, 237, 0.14);
  stroke: rgba(255, 107, 237, 0.45);
}
.memory-timeline :deep(.loop-text) { fill: #ff9bf2; }

/* reveal / highlight states */
.memory-timeline :deep(.mt-item),
.memory-timeline :deep(.mt-chatbot),
.memory-timeline :deep(.mt-loop),
.memory-timeline :deep(.mt-punch) {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.memory-timeline :deep(.hidden) { opacity: 0; pointer-events: none; }
.memory-timeline :deep(.shown) { opacity: 1; }
.memory-timeline :deep(.active) { opacity: 1; }
.memory-timeline :deep(.mt-item.hidden) { transform: translateY(10px); }

/* dim the already-revealed cards a touch so the newest one pops */
.memory-timeline :deep(.mt-item.shown) { opacity: 0.82; }
.memory-timeline :deep(.mt-item.shown) .card-bg { stroke: rgba(255, 107, 237, 0.16); }
.memory-timeline :deep(.mt-chatbot.shown) { opacity: 0.25; }
</style>
