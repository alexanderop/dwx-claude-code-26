<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{ step?: number }>(), { step: 0 })

const steps = [
  {
    label: '1. Bound the task',
    title: 'Turn the ask into browser-safe instructions',
    command: 'agent-browser --session otto --allowed-domains otto.de open https://www.otto.de',
    note: 'Stay on OTTO. Add to cart is allowed; checkout waits for human confirmation.',
    image: '/agent-browser-otto/01-home.png',
    snapshot: [
      '@e23 link "Zur OTTO-Startseite"',
      '@e72 searchbox "Wonach suchst du?"',
      '@e98 link "Warenkorb"',
      '@e93 button "OK"',
    ],
  },
  {
    label: '2. Read the page',
    title: 'Ask the browser for an accessibility snapshot',
    command: 'agent-browser snapshot -i',
    note: 'The page becomes compact text with fresh @refs for inputs, buttons, and links.',
    image: '/agent-browser-otto/02-home-clean.png',
    snapshot: [
      '@e71 searchbox "Wonach suchst du?"',
      '@e91 button "Suche abschicken"',
      '@e93 link "Warenkorb"',
      '@e101 link "Multimedia"',
    ],
  },
  {
    label: '3. Act by ref',
    title: 'Search like a user, not with brittle selectors',
    command: 'agent-browser fill @e71 "Kopfhörer" && agent-browser press Enter',
    note: 'The CLI keeps Chromium alive across commands, so every command continues the same session.',
    image: '/agent-browser-otto/03-search-results.png',
    snapshot: [
      '@e60 searchbox "Wonach suchst du?": kopfhörer',
      '@e65 button "Suchbegriff löschen"',
      '@e66 button "Suche abschicken"',
      '@e68 link "Warenkorb"',
    ],
  },
  {
    label: '4. Re-snapshot',
    title: 'Refs are disposable after the page changes',
    command: 'agent-browser wait --load networkidle && agent-browser snapshot -i',
    note: '@e4 from the home page is stale now. The results page gets a new ref map.',
    image: '/agent-browser-otto/03-search-results.png',
    snapshot: [
      '@e19 heading "kopfhörer"',
      '@e365 checkbox "In-Ear-Kopfhörer"',
      '@e506 checkbox "Sony"',
      '@e507 checkbox "JBL"',
    ],
  },
  {
    label: '5. Complete the action',
    title: 'Open a result, then use the next add-to-cart ref',
    command: 'agent-browser click @e224 && agent-browser snapshot -i',
    note: 'Cookie banners, size pickers, and modals are just more refs in the loop.',
    image: '/agent-browser-otto/04-product-cards.png',
    snapshot: [
      '@e224 link "Sony WH1000XM5..."',
      '@e222 link "APPLE AirPods Pro 3..."',
      '@e128 rating "(38)"',
      '@e129 button "Schwarz"',
    ],
  },
  {
    label: '6. Verify evidence',
    title: 'Read the outcome before reporting done',
    command: 'agent-browser errors && agent-browser screenshot --annotate',
    note: 'The agent reports what it saw: cart count, visible confirmation, errors, and screenshot evidence.',
    image: '/agent-browser-otto/04-product-cards.png',
    snapshot: [
      'verify: visible product choice',
      'verify: no browser errors',
      'verify: screenshot saved',
      'stop: checkout/payment needs approval',
    ],
  },
]

const currentIndex = computed(() => Math.min(Math.max(props.step, 0), steps.length - 1))
const current = computed(() => steps[currentIndex.value])

function stateFor(index: number) {
  if (index < currentIndex.value) return 'done'
  if (index === currentIndex.value) return 'active'
  return 'todo'
}
</script>

<template>
  <div class="otto-flow">
    <div class="flow-steps" aria-label="agent-browser OTTO task steps">
      <div
        v-for="(item, index) in steps"
        :key="item.label"
        class="flow-step"
        :class="stateFor(index)"
      >
        <div class="step-index">{{ item.label }}</div>
        <div class="step-title">{{ item.title }}</div>
        <div class="step-note">{{ item.note }}</div>
      </div>
    </div>

    <div class="flow-stage">
      <div class="visual-card">
        <div class="visual-top">
          <span>real OTTO.de screenshot</span>
          <strong>{{ current.label }}</strong>
        </div>
        <div class="screenshot-frame">
          <img :src="current.image" alt="OTTO.de browser state for this agent-browser step" />
          <div class="hotspot" :class="`step-${currentIndex + 1}`"></div>
        </div>
      </div>

      <div class="agent-view">
        <div class="agent-view-title">what the agent sees</div>
        <div class="command-line">{{ current.command }}</div>
        <div v-for="line in current.snapshot" :key="line" class="snapshot-line">{{ line }}</div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.otto-flow {
  display: grid;
  grid-template-columns: 0.92fr 1.08fr;
  gap: 22px;
  align-items: start;
  width: 100%;
  max-width: 1080px;
  margin: 0 auto;
}

.flow-steps {
  display: grid;
  gap: 6px;
}

.flow-step {
  border: 1px solid rgba(255,255,255,0.09);
  background: rgba(255,255,255,0.04);
  border-radius: 8px;
  padding: 7px 10px;
  opacity: 0.48;
  transition: opacity 180ms ease, border-color 180ms ease, background 180ms ease;
}

.flow-step.done {
  opacity: 0.72;
  border-color: rgba(52,211,153,0.24);
}

.flow-step.active {
  opacity: 1;
  border-color: rgba(255,107,237,0.65);
  background: linear-gradient(135deg, rgba(255,107,237,0.14), rgba(255,255,255,0.045));
  box-shadow: 0 0 22px -10px rgba(255,107,237,0.9);
}

.step-index {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 9px;
  color: #ff6bed;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.step-title {
  margin-top: 2px;
  font-size: 12px;
  font-weight: 700;
  color: rgba(234,237,243,0.96);
}

.step-note {
  display: none;
  margin-top: 4px;
  font-size: 11px;
  line-height: 1.35;
  color: rgba(234,237,243,0.62);
}

.flow-step.active .step-note {
  display: block;
}

.flow-stage {
  display: grid;
  grid-template-rows: auto auto;
  gap: 10px;
}

.visual-card,
.agent-view {
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 8px;
  background: rgba(8,10,18,0.78);
}

.visual-card {
  overflow: hidden;
  box-shadow: 0 24px 70px -44px rgba(255,107,237,0.9);
}

.visual-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 11px;
  border-bottom: 1px solid rgba(255,255,255,0.08);
  background: rgba(255,255,255,0.045);
}

.visual-top span,
.visual-top strong {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 10px;
}

.visual-top span {
  color: rgba(234,237,243,0.62);
}

.visual-top strong {
  color: #ff6bed;
}

.screenshot-frame {
  position: relative;
  aspect-ratio: 16 / 6.55;
  overflow: hidden;
  background: #f3f4f6;
}

.screenshot-frame img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.hotspot {
  position: absolute;
  border: 2px solid #ff6bed;
  border-radius: 999px;
  box-shadow: 0 0 0 999px rgba(8,10,18,0.08), 0 0 20px rgba(255,107,237,0.85);
  pointer-events: none;
}

.hotspot.step-1 {
  left: 14.8%;
  top: 4.6%;
  width: 38%;
  height: 9%;
}

.hotspot.step-2 {
  left: 15%;
  top: 4.5%;
  width: 38%;
  height: 9%;
}

.hotspot.step-3,
.hotspot.step-4 {
  left: 14.5%;
  top: 63%;
  width: 68%;
  height: 22%;
}

.hotspot.step-5,
.hotspot.step-6 {
  left: 22%;
  top: 18%;
  width: 60%;
  height: 72%;
}

.agent-view {
  display: grid;
  gap: 2px;
  padding: 7px 10px;
}

.agent-view-title,
.command-line {
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
}

.agent-view-title {
  font-size: 10px;
  color: rgba(234,237,243,0.48);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.command-line {
  color: #ff6bed;
  font-size: 10px;
  line-height: 1.25;
  padding-bottom: 2px;
}

.snapshot-line {
  border: 1px dashed rgba(255,107,237,0.28);
  border-radius: 5px;
  background: rgba(255,107,237,0.045);
  padding: 3px 8px;
  color: rgba(234,237,243,0.78);
  font-family: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, monospace;
  font-size: 9.5px;
  line-height: 1.25;
}

</style>
