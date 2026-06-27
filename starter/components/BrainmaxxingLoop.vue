<script setup lang="ts">
const props = withDefaults(defineProps<{ step?: number }>(), { step: 0 })

const TOTAL_STEPS = 6
const HOOKS_STEP = 6

function classFor(n: number) {
  // Click 0 (initial) and click TOTAL_STEPS+1 (final) show the whole diagram.
  if (props.step === 0 || props.step > TOTAL_STEPS) return 'step'
  if (props.step === n) return 'step is-active'
  // On the hooks reveal, keep the rest of the loop fully visible — hooks live ON the existing edges.
  if (props.step === HOOKS_STEP) return 'step'
  return 'step is-dim'
}
</script>

<template>
  <div class="brainmaxxing-loop" :data-step="props.step">
    <svg
      viewBox="0 0 900 420"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="brainmaxxing loop: /reflect writes into brain/, /plan and /review read principles back, /meditate prunes the vault"
    >
      <defs>
        <marker id="bm-arrow-pink" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
          <path d="M0,0 L10,5 L0,10 z" fill="#ff6bed" />
        </marker>
        <marker id="bm-arrow-light" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
          <path d="M0,0 L10,5 L0,10 z" fill="rgba(234,237,243,0.7)" />
        </marker>
        <marker id="bm-arrow-mute" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
          <path d="M0,0 L10,5 L0,10 z" fill="rgba(234,237,243,0.4)" />
        </marker>
        <filter id="bm-brain-glow" x="-30%" y="-30%" width="160%" height="160%">
          <feGaussianBlur stdDeviation="6" result="blur" />
          <feMerge>
            <feMergeNode in="blur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
        <linearGradient id="bm-brain-fill" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stop-color="rgba(255,107,237,0.18)" />
          <stop offset="100%" stop-color="rgba(255,107,237,0.06)" />
        </linearGradient>
      </defs>

      <!-- STEP 1: work with Claude (origin) -->
      <g :class="classFor(1)">
        <g transform="translate(330,18)">
          <rect width="240" height="56" rx="28" fill="rgba(52,63,96,0.7)" stroke="rgba(234,237,243,0.35)" />
          <text x="120" y="26" text-anchor="middle" class="xs muted">you</text>
          <text x="120" y="46" text-anchor="middle" class="md semibold">work with Claude</text>
        </g>
      </g>

      <!-- STEP 2: the writers — /reflect + /ruminate both feed brain/ -->
      <g :class="classFor(2)">
        <!-- /reflect card -->
        <g transform="translate(60,128)">
          <rect width="200" height="60" rx="10" fill="rgba(52,63,96,0.85)" stroke="rgba(255,107,237,0.55)" />
          <text x="100" y="26" text-anchor="middle" class="md bold accent">/reflect</text>
          <text x="100" y="46" text-anchor="middle" class="sm muted">capture session learnings</text>
        </g>
        <!-- /ruminate card -->
        <g transform="translate(60,212)">
          <rect width="200" height="60" rx="10" fill="rgba(52,63,96,0.85)" stroke="rgba(255,107,237,0.55)" />
          <text x="100" y="26" text-anchor="middle" class="md bold accent">/ruminate</text>
          <text x="100" y="46" text-anchor="middle" class="sm muted">mine past conversations</text>
        </g>
        <!-- work → /reflect (trigger label) -->
        <path d="M 360 74 Q 240 100 220 128" fill="none" stroke="rgba(234,237,243,0.7)" stroke-width="1.5" marker-end="url(#bm-arrow-light)" />
        <text x="248" y="112" text-anchor="middle" class="xs muted">at session end</text>
        <!-- /reflect → brain/ (writes, pink) -->
        <path d="M 260 158 L 330 195" fill="none" stroke="#ff6bed" stroke-width="2" marker-end="url(#bm-arrow-pink)" />
        <!-- /ruminate → brain/ (mines, pink) -->
        <path d="M 260 242 L 330 245" fill="none" stroke="#ff6bed" stroke-width="2" marker-end="url(#bm-arrow-pink)" />
      </g>

      <!-- STEP 3: brain/ vault -->
      <g :class="classFor(3)">
        <g transform="translate(330,140)" filter="url(#bm-brain-glow)">
          <rect width="240" height="160" rx="14" fill="url(#bm-brain-fill)" stroke="#ff6bed" stroke-width="1.5" />
          <path d="M14,0 L70,0 L80,-12 L24,-12 Z" fill="#ff6bed" opacity="0.9" />
          <text x="46" y="-2" text-anchor="middle" class="xs bold tab-label">brain/</text>
          <g class="vault-contents">
            <text x="20" y="32" class="mono" opacity="0.55">brain/</text>
            <text x="32" y="54" class="mono">├── principles/</text>
            <text x="32" y="74" class="mono" opacity="0.75">├── codebase/</text>
            <text x="32" y="94" class="mono" opacity="0.75">├── inbox/</text>
            <text x="32" y="114" class="mono" opacity="0.75">└── index.md</text>
          </g>
          <text x="120" y="146" text-anchor="middle" class="xs muted">a markdown vault that learns</text>
        </g>
      </g>

      <!-- STEP 4: /plan + /review read principles, loop back -->
      <g :class="classFor(4)">
        <g transform="translate(640,128)">
          <rect width="200" height="44" rx="10" fill="rgba(52,63,96,0.85)" stroke="rgba(234,237,243,0.4)" />
          <text x="16" y="28" class="md bold">/plan</text>
          <text x="76" y="28" class="sm muted">read → propose</text>
        </g>
        <g transform="translate(640,184)">
          <rect width="200" height="44" rx="10" fill="rgba(52,63,96,0.85)" stroke="rgba(234,237,243,0.4)" />
          <text x="16" y="28" class="md bold">/review</text>
          <text x="86" y="28" class="sm muted">read → critique</text>
        </g>
        <!-- brain/ → /plan -->
        <path d="M 570 180 L 640 150" fill="none" stroke="rgba(234,237,243,0.7)" stroke-width="1.5" stroke-dasharray="4 3" marker-end="url(#bm-arrow-light)" />
        <!-- brain/ → /review -->
        <path d="M 570 240 L 640 206" fill="none" stroke="rgba(234,237,243,0.7)" stroke-width="1.5" stroke-dasharray="4 3" marker-end="url(#bm-arrow-light)" />
        <g transform="translate(580,196)">
          <rect width="70" height="18" rx="4" fill="rgba(234,237,243,0.9)" />
          <text x="35" y="13" text-anchor="middle" class="xs bold chip-on-light">principles</text>
        </g>
        <!-- /plan + /review → work with Claude (next session) -->
        <path d="M 740 128 Q 740 60 570 50" fill="none" stroke="rgba(234,237,243,0.7)" stroke-width="1.5" marker-end="url(#bm-arrow-light)" />
      </g>

      <!-- STEP 5: /meditate prunes -->
      <g :class="classFor(5)">
        <g transform="translate(330,344)">
          <rect width="240" height="60" rx="10" fill="rgba(52,63,96,0.85)" stroke="rgba(234,237,243,0.3)" />
          <text x="120" y="24" text-anchor="middle" class="md bold">/meditate</text>
          <text x="120" y="44" text-anchor="middle" class="sm muted">audit skills · evolve principles · prune</text>
        </g>
        <path d="M 450 344 L 450 300" fill="none" stroke="rgba(234,237,243,0.5)" stroke-width="1.5" stroke-dasharray="4 3" marker-end="url(#bm-arrow-mute)" />
        <g transform="translate(420,316)">
          <rect width="60" height="18" rx="4" fill="rgba(234,237,243,0.3)" />
          <text x="30" y="13" text-anchor="middle" class="xs bold">tends</text>
        </g>
      </g>

      <!-- STEP 6: hooks — the glue that makes the loop automatic -->
      <g :class="classFor(6)">
        <!-- PostToolUse hook — sits between writes/mines, just left of brain/. -->
        <g transform="translate(212,196)">
          <rect width="116" height="38" rx="6" fill="rgba(160,210,255,0.22)" stroke="rgba(160,210,255,0.9)" stroke-width="1.3" stroke-dasharray="3 2" />
          <text x="58" y="15" text-anchor="middle" class="xs bold chip-hook">PostToolUse hook</text>
          <text x="58" y="29" text-anchor="middle" class="hook-trigger">fires on every brain/ write</text>
        </g>

        <!-- SessionStart hook — sits above the next-session arc. -->
        <g transform="translate(590,6)">
          <rect width="170" height="38" rx="6" fill="rgba(160,210,255,0.22)" stroke="rgba(160,210,255,0.9)" stroke-width="1.3" stroke-dasharray="3 2" />
          <text x="85" y="15" text-anchor="middle" class="xs bold chip-hook">SessionStart hook</text>
          <text x="85" y="29" text-anchor="middle" class="hook-trigger">fires on every new session</text>
        </g>
        <!-- short dashed connector from SessionStart chip down to the arc -->
        <line x1="675" y1="44" x2="675" y2="64" stroke="rgba(160,210,255,0.75)" stroke-width="1.2" stroke-dasharray="2 2" />
      </g>

      <!-- legend (always visible) -->
      <g transform="translate(60,388)">
        <circle cx="6" cy="6" r="5" fill="#ff6bed" />
        <text x="18" y="10" class="xs">writes into brain/</text>
        <g transform="translate(150,0)">
          <line x1="0" y1="6" x2="14" y2="6" stroke="rgba(234,237,243,0.7)" stroke-width="1.5" stroke-dasharray="3 2" />
          <text x="22" y="10" class="xs">reads from brain/</text>
        </g>
        <g transform="translate(300,0)">
          <rect x="0" y="1" width="14" height="10" rx="2" fill="rgba(160,210,255,0.22)" stroke="rgba(160,210,255,0.9)" stroke-dasharray="2 1" />
          <text x="22" y="10" class="xs">hook fires automatically</text>
        </g>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.brainmaxxing-loop {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}

.brainmaxxing-loop svg {
  width: 100%;
  max-width: 100%;
  max-height: 100%;
  height: auto;
}

.brainmaxxing-loop :deep(text) {
  font-family: Geist, ui-sans-serif, system-ui, sans-serif;
  font-size: 14px;
  font-weight: 400;
  line-height: 1;
  letter-spacing: normal;
  fill: #eaedf3;
}

.brainmaxxing-loop :deep(.xs) { font-size: 11px; }
.brainmaxxing-loop :deep(.sm) { font-size: 12px; }
.brainmaxxing-loop :deep(.md) { font-size: 13px; }
.brainmaxxing-loop :deep(.bold) { font-weight: 700; }
.brainmaxxing-loop :deep(.semibold) { font-weight: 600; }
.brainmaxxing-loop :deep(.muted) { opacity: 0.6; }
.brainmaxxing-loop :deep(.accent) { fill: #ff6bed; }
.brainmaxxing-loop :deep(.mono) {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 12px;
}
.brainmaxxing-loop :deep(.tab-label) { fill: #212737; }
.brainmaxxing-loop :deep(.chip-on-pink) { fill: #212737; }
.brainmaxxing-loop :deep(.chip-on-light) { fill: #212737; }
.brainmaxxing-loop :deep(.chip-hook) { fill: #d8ecff; }
.brainmaxxing-loop :deep(.hook-trigger) {
  fill: #d8ecff;
  font-size: 9.5px;
  opacity: 0.78;
  font-style: italic;
}

/* step highlighting */
.brainmaxxing-loop :deep(.step) {
  transition: opacity 0.3s ease, filter 0.3s ease;
}
.brainmaxxing-loop :deep(.step.is-dim) {
  opacity: 0.18;
}
.brainmaxxing-loop :deep(.step.is-active) {
  filter: drop-shadow(0 0 10px rgba(255, 107, 237, 0.45));
}
</style>
