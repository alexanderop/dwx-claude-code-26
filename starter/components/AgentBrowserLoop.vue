<script setup lang="ts">
const props = withDefaults(defineProps<{ step?: number }>(), { step: 0 })

const nodes = {
  agent:   { x: 180, y: 140, label: 'AGENT',         sub: 'writes code' },
  app:     { x: 720, y: 140, label: 'LOCAL APP',     sub: 'pnpm dev · :5173' },
  browser: { x: 450, y: 380, label: 'AGENT-BROWSER', sub: 'real Chromium' },
}

function isShown(n: number) {
  return props.step >= n
}
</script>

<template>
  <div class="agent-browser-loop" :data-step="props.step">
    <svg
      viewBox="0 0 900 500"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="The agent runs the app locally, drives a real browser, and reads the result back as feedback."
    >
      <defs>
        <linearGradient id="abl-node" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="rgba(255,107,237,0.22)" />
          <stop offset="100%" stop-color="rgba(255,107,237,0.04)" />
        </linearGradient>
        <filter id="abl-glow" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="4" result="b" />
          <feMerge>
            <feMergeNode in="b" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
        <marker id="abl-arrow" viewBox="0 0 10 10" refX="9" refY="5"
          markerWidth="6" markerHeight="6" orient="auto-start-reverse">
          <path d="M 0 0 L 10 5 L 0 10 z" fill="#ff6bed" />
        </marker>
      </defs>

      <!-- Step 1: Agent starts the local app -->
      <g :class="['edge', { 'is-shown': isShown(1) }]">
        <path
          d="M 260 140 L 640 140"
          fill="none" stroke="#ff6bed" stroke-width="1.6"
          marker-end="url(#abl-arrow)"
        />
        <text x="450" y="120" text-anchor="middle" class="edge-label">starts locally</text>
      </g>

      <!-- Step 2: Agent drives the browser, browser hits the app -->
      <g :class="['edge', { 'is-shown': isShown(2) }]">
        <path
          d="M 230 195 Q 250 320 380 360"
          fill="none" stroke="#ff6bed" stroke-width="1.6"
          marker-end="url(#abl-arrow)"
        />
        <text x="220" y="290" text-anchor="end" class="edge-label">drives</text>

        <path
          d="M 520 360 Q 660 320 690 195"
          fill="none" stroke="#ff6bed" stroke-width="1.6"
          marker-end="url(#abl-arrow)"
        />
        <text x="680" y="290" text-anchor="start" class="edge-label">clicks · types · scrolls</text>
      </g>

      <!-- Step 3: Browser feeds DOM / screenshots / console back to agent -->
      <g :class="['edge feedback', { 'is-shown': isShown(3) }]">
        <path
          d="M 380 360 Q 220 360 200 200"
          fill="none" stroke="#ff6bed" stroke-width="1.6"
          stroke-dasharray="6 5"
          marker-end="url(#abl-arrow)"
        />
        <text x="170" y="360" text-anchor="end" class="edge-label">DOM · screenshots · console</text>
      </g>

      <!-- Nodes -->
      <g v-for="(n, key) in nodes" :key="key" class="node" :class="{ 'is-on': isShown(1) }">
        <rect
          :x="n.x - 80" :y="n.y - 38" width="160" height="76" rx="14" ry="14"
          fill="url(#abl-node)" stroke="#ff6bed" stroke-width="1.4"
        />
        <text :x="n.x" :y="n.y - 6" text-anchor="middle" class="node-title">{{ n.label }}</text>
        <text :x="n.x" :y="n.y + 16" text-anchor="middle" class="node-sub">{{ n.sub }}</text>
      </g>

      <!-- Closed-loop badge once feedback is wired -->
      <g :class="['closed', { 'is-on': isShown(3) }]" filter="url(#abl-glow)">
        <rect x="370" y="225" width="160" height="38" rx="19" ry="19"
          fill="rgba(255,107,237,0.12)" stroke="#ff6bed" stroke-width="1.4" />
        <text x="450" y="250" text-anchor="middle" class="closed-label">CLOSED LOOP</text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.agent-browser-loop {
  display: flex;
  justify-content: center;
  width: 100%;
}

.agent-browser-loop svg {
  width: 100%;
  max-width: 820px;
  height: auto;
}

.agent-browser-loop :deep(text) {
  font-family: Geist, ui-sans-serif, system-ui, sans-serif;
  fill: #eaedf3;
}

.agent-browser-loop :deep(.node-title) {
  font-size: 14px;
  font-weight: 700;
  fill: #ff6bed;
  letter-spacing: 0.06em;
}
.agent-browser-loop :deep(.node-sub) {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 11px;
  fill: rgba(234,237,243,0.65);
}
.agent-browser-loop :deep(.edge-label) {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 11px;
  fill: rgba(234,237,243,0.7);
}
.agent-browser-loop :deep(.closed-label) {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.16em;
  fill: #ff6bed;
}

.agent-browser-loop :deep(.node) {
  opacity: 0.35;
  transition: opacity 0.45s ease;
}
.agent-browser-loop :deep(.node.is-on) { opacity: 1; }

.agent-browser-loop :deep(.edge) {
  opacity: 0;
  transition: opacity 0.45s ease;
}
.agent-browser-loop :deep(.edge.is-shown) {
  opacity: 1;
  animation: abl-pop 0.55s cubic-bezier(0.22, 1, 0.36, 1);
}
@keyframes abl-pop {
  0%   { filter: drop-shadow(0 0 0 rgba(255,107,237,0)); }
  45%  { filter: drop-shadow(0 0 12px rgba(255,107,237,0.7)); }
  100% { filter: drop-shadow(0 0 0 rgba(255,107,237,0)); }
}

.agent-browser-loop :deep(.feedback.is-shown path) {
  animation: abl-dash 1.6s linear infinite;
}
@keyframes abl-dash {
  to { stroke-dashoffset: -22; }
}

.agent-browser-loop :deep(.closed) {
  opacity: 0;
  transition: opacity 0.5s ease;
}
.agent-browser-loop :deep(.closed.is-on) {
  opacity: 1;
  animation: abl-breath 2.6s ease-in-out infinite;
}
@keyframes abl-breath {
  0%, 100% { filter: drop-shadow(0 0 6px rgba(255,107,237,0.45)); }
  50%      { filter: drop-shadow(0 0 18px rgba(255,107,237,0.95)); }
}

@media (prefers-reduced-motion: reduce) {
  .agent-browser-loop :deep(.node),
  .agent-browser-loop :deep(.edge),
  .agent-browser-loop :deep(.closed) { transition: none; animation: none; }
  .agent-browser-loop :deep(.feedback.is-shown path) { animation: none; }
}
</style>
