<script setup lang="ts">
const props = withDefaults(defineProps<{ step?: number }>(), { step: 0 })

const cx = 450
const cy = 250
const rOuter = 205
const rInner = 70
const rLabel = 137

function pt(angleDeg: number, r: number) {
  const a = (angleDeg * Math.PI) / 180
  return [cx + r * Math.sin(a), cy - r * Math.cos(a)] as const
}

function slicePath(a1: number, a2: number) {
  const [ox1, oy1] = pt(a1, rOuter)
  const [ox2, oy2] = pt(a2, rOuter)
  const [ix1, iy1] = pt(a1, rInner)
  const [ix2, iy2] = pt(a2, rInner)
  const large = a2 - a1 > 180 ? 1 : 0
  return `M ${ox1},${oy1} A ${rOuter},${rOuter} 0 ${large} 1 ${ox2},${oy2} L ${ix2},${iy2} A ${rInner},${rInner} 0 ${large} 0 ${ix1},${iy1} Z`
}

type Slice = {
  n: number
  label: string
  title: string
  sub: string
  start: number
  end: number
}

const slices: Slice[] = [
  { n: 1, label: '01', title: 'AGENTS.md',    sub: 'foundation',           start: 0,   end: 90  },
  { n: 2, label: '02', title: 'brainmaxxing', sub: 'skills · hooks · brain/', start: 90,  end: 180 },
  { n: 3, label: '03', title: 'feedback',     sub: 'pipeline of signals',  start: 180, end: 270 },
  { n: 4, label: '04', title: 'features',     sub: 'vertical slices',      start: 270, end: 360 },
]

function labelPos(s: Slice) {
  const mid = (s.start + s.end) / 2
  return pt(mid, rLabel)
}

function isShown(n: number) {
  return props.step >= n
}
</script>

<template>
  <div class="agent-ready-pie" :data-step="props.step">
    <svg
      viewBox="200 30 500 440"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="Four moves compound into an agent-ready codebase: AGENTS.md, brainmaxxing, feedback pipeline, feature architecture."
    >
      <defs>
        <linearGradient id="arp-slice" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="rgba(255,107,237,0.28)" />
          <stop offset="100%" stop-color="rgba(255,107,237,0.06)" />
        </linearGradient>
        <radialGradient id="arp-core" cx="50%" cy="50%" r="50%">
          <stop offset="0%"  stop-color="rgba(255,107,237,0.95)" />
          <stop offset="55%" stop-color="rgba(255,107,237,0.25)" />
          <stop offset="100%" stop-color="rgba(255,107,237,0)" />
        </radialGradient>
        <filter id="arp-glow" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="5" result="b" />
          <feMerge>
            <feMergeNode in="b" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>

      <!-- empty ring guide (always visible) -->
      <circle :cx="cx" :cy="cy" :r="rOuter" fill="none" stroke="rgba(234,237,243,0.08)" stroke-width="1" />
      <circle :cx="cx" :cy="cy" :r="rInner" fill="none" stroke="rgba(234,237,243,0.08)" stroke-width="1" />

      <!-- slices -->
      <g v-for="s in slices" :key="s.n" :class="['slice', { 'is-shown': isShown(s.n) }]">
        <path
          :d="slicePath(s.start, s.end)"
          fill="url(#arp-slice)"
          stroke="#ff6bed"
          stroke-width="1.4"
          stroke-linejoin="round"
        />
      </g>

      <!-- labels (revealed with their slice) -->
      <g v-for="s in slices" :key="`l-${s.n}`" :class="['label', { 'is-shown': isShown(s.n) }]">
        <g :transform="`translate(${labelPos(s)[0]}, ${labelPos(s)[1]})`">
          <text text-anchor="middle" y="-18" class="num">{{ s.label }}</text>
          <text text-anchor="middle" y="2"   class="title">{{ s.title }}</text>
          <text text-anchor="middle" y="22"  class="sub">{{ s.sub }}</text>
        </g>
      </g>

      <!-- center beacon: lights up at step 5 -->
      <g :class="['beacon', { 'is-on': props.step >= 5 }]" filter="url(#arp-glow)">
        <circle :cx="cx" :cy="cy" :r="rInner - 4" fill="url(#arp-core)" />
        <circle class="beacon-ring" :cx="cx" :cy="cy" :r="rInner - 18"
          fill="none" stroke="#ff6bed" stroke-width="1.4" stroke-dasharray="5 4" />
        <text :x="cx" :y="cy - 4" text-anchor="middle" class="beacon-label">AGENT</text>
        <text :x="cx" :y="cy + 14" text-anchor="middle" class="beacon-label">READY</text>
      </g>

      <!-- expanding ripple once beacon is on -->
      <circle
        v-if="props.step >= 5"
        class="ripple"
        :cx="cx" :cy="cy" :r="rInner"
        fill="none" stroke="#ff6bed" stroke-width="1.2"
      />
    </svg>
  </div>
</template>

<style scoped>
.agent-ready-pie {
  display: flex;
  justify-content: center;
  width: 100%;
}

.agent-ready-pie svg {
  width: 100%;
  max-width: 760px;
  height: auto;
}

.agent-ready-pie :deep(text) {
  font-family: Geist, ui-sans-serif, system-ui, sans-serif;
  fill: #eaedf3;
}

.agent-ready-pie :deep(.num) {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 13px;
  fill: rgba(234,237,243,0.55);
  font-weight: 500;
}
.agent-ready-pie :deep(.title) {
  font-size: 18px;
  font-weight: 700;
  fill: #ff6bed;
  letter-spacing: -0.01em;
}
.agent-ready-pie :deep(.sub) {
  font-size: 11px;
  fill: rgba(234,237,243,0.6);
}
.agent-ready-pie :deep(.beacon-label) {
  font-size: 14px;
  font-weight: 700;
  fill: #ff6bed;
  letter-spacing: 0.14em;
}

/* slices: fade in + grow on appearance, then settle */
.agent-ready-pie :deep(.slice) {
  opacity: 0;
  transition: opacity 0.45s ease;
}
.agent-ready-pie :deep(.slice.is-shown) {
  opacity: 1;
  animation: arp-pop 0.55s cubic-bezier(0.22, 1, 0.36, 1);
}
@keyframes arp-pop {
  0%   { filter: drop-shadow(0 0 0 rgba(255,107,237,0)); }
  40%  { filter: drop-shadow(0 0 14px rgba(255,107,237,0.7)); }
  100% { filter: drop-shadow(0 0 0 rgba(255,107,237,0)); }
}

/* labels: fade in slightly after their slice */
.agent-ready-pie :deep(.label) {
  opacity: 0;
  transition: opacity 0.5s ease 0.15s;
}
.agent-ready-pie :deep(.label.is-shown) { opacity: 1; }

/* beacon: hidden until step 5 */
.agent-ready-pie :deep(.beacon) {
  opacity: 0;
  transition: opacity 0.5s ease;
}
.agent-ready-pie :deep(.beacon.is-on) {
  opacity: 1;
  animation: arp-beacon-breath 2.6s ease-in-out infinite;
}
@keyframes arp-beacon-breath {
  0%, 100% { filter: drop-shadow(0 0 6px rgba(255,107,237,0.45)); }
  50%      { filter: drop-shadow(0 0 18px rgba(255,107,237,0.9)); }
}
.agent-ready-pie :deep(.beacon.is-on .beacon-ring) {
  transform-origin: 450px 250px;
  animation: arp-ring-spin 14s linear infinite;
}
@keyframes arp-ring-spin {
  to { transform: rotate(360deg); }
}

/* ripple emitted when beacon lights up */
.agent-ready-pie :deep(.ripple) {
  transform-origin: 450px 250px;
  animation: arp-ripple 2.6s ease-out infinite;
}
@keyframes arp-ripple {
  0%   { opacity: 0.7; transform: scale(1); }
  100% { opacity: 0;   transform: scale(2.2); }
}

@media (prefers-reduced-motion: reduce) {
  .agent-ready-pie :deep(.slice),
  .agent-ready-pie :deep(.label),
  .agent-ready-pie :deep(.beacon) { transition: none; animation: none; }
  .agent-ready-pie :deep(.beacon.is-on .beacon-ring),
  .agent-ready-pie :deep(.ripple) { animation: none; }
}
</style>
