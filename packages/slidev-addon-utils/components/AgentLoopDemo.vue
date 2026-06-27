<template>
  <div class="agent-demo" :class="{ 'agent-demo--idle': state === 'idle' }">
    <div class="agent-demo__chrome">
      <div class="agent-demo__dots">
        <span /><span /><span />
      </div>
      <div class="agent-demo__title">claude-code · vue-shop</div>
      <button
        class="agent-demo__replay"
        :disabled="state === 'typing' || state === 'running'"
        @click="play"
      >
        <span class="i-ph-arrow-clockwise-bold" />
        {{ state === 'done' ? 'replay' : 'play' }}
      </button>
    </div>

    <div ref="bodyEl" class="agent-demo__body">
      <div class="agent-demo__prompt-line">
        <span class="agent-demo__chevron">&gt;</span>
        <span class="agent-demo__prompt">{{ typedPrompt }}</span>
        <span v-if="state === 'idle' || state === 'typing'" class="agent-demo__caret">▍</span>
      </div>

      <transition name="thinking">
        <div v-if="state === 'thinking'" class="agent-demo__thinking">
          <span class="agent-demo__dot" />
          <span class="agent-demo__dot" />
          <span class="agent-demo__dot" />
          <span class="agent-demo__thinking-label">thinking</span>
        </div>
      </transition>

      <template v-for="(iter, ii) in visibleIterations" :key="ii">
        <div class="agent-demo__iter">
          <div class="agent-demo__iter-label">
            <span class="agent-demo__iter-tag">loop iteration {{ ii + 1 }}</span>
          </div>
          <transition-group name="call" tag="div" class="agent-demo__calls">
            <div
              v-for="call in iter"
              :key="call.id"
              class="agent-demo__call"
              :class="`agent-demo__call--${call.tool}`"
            >
              <span class="agent-demo__tool" :class="`tool-${call.tool}`">
                {{ call.tool }}
              </span>
              <span class="agent-demo__args">{{ call.args }}</span>
              <span class="agent-demo__status">
                <template v-if="call.status === 'running'">
                  <span class="agent-demo__spinner" />
                </template>
                <template v-else-if="call.status === 'ok'">
                  <span class="agent-demo__ok i-ph-check-bold" />
                  <span class="agent-demo__duration">{{ call.duration }}</span>
                </template>
                <template v-else-if="call.status === 'fail'">
                  <span class="agent-demo__fail i-ph-x-bold" />
                  <span class="agent-demo__duration agent-demo__duration--fail">{{ call.duration }}</span>
                </template>
              </span>
            </div>
          </transition-group>
        </div>
      </template>

      <transition name="thinking">
        <div v-if="state === 'done'" class="agent-demo__done">
          <span class="i-ph-check-circle-fill" />
          <span>feature shipped · PR ready for review</span>
        </div>
      </transition>
    </div>
  </div>
</template>

<script setup lang="ts">
import { nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'

type ToolName = 'Read' | 'Grep' | 'Edit' | 'Bash' | 'context7'

interface ToolCall {
  id: number
  tool: ToolName
  args: string
  duration: string
  durationMs: number
  result: 'ok' | 'fail'
  status: 'running' | 'ok' | 'fail'
}

interface IterationDef {
  calls: Array<Omit<ToolCall, 'id' | 'status'>>
}

const PROMPT = 'add a dark-mode toggle to the header'

const SCRIPT: IterationDef[] = [
  {
    calls: [
      { tool: 'Read', args: 'src/App.vue', duration: '142ms', durationMs: 380, result: 'ok' },
      { tool: 'Grep', args: '"theme" → 8 hits', duration: '31ms', durationMs: 280, result: 'ok' },
      { tool: 'Read', args: 'src/composables/useTheme.ts', duration: '88ms', durationMs: 320, result: 'ok' },
    ],
  },
  {
    calls: [
      { tool: 'context7', args: 'vue docs · composables', duration: '821ms', durationMs: 520, result: 'ok' },
      { tool: 'Edit', args: 'src/composables/useTheme.ts', duration: '64ms', durationMs: 360, result: 'ok' },
    ],
  },
  {
    calls: [
      { tool: 'Bash', args: 'pnpm vitest run theme', duration: '4.2s', durationMs: 700, result: 'fail' },
      { tool: 'Read', args: 'tests/theme.spec.ts', duration: '18ms', durationMs: 300, result: 'ok' },
      { tool: 'Edit', args: 'src/composables/useTheme.ts', duration: '72ms', durationMs: 340, result: 'ok' },
      { tool: 'Bash', args: 'pnpm vitest run theme', duration: '3.8s', durationMs: 700, result: 'ok' },
    ],
  },
]

type State = 'idle' | 'typing' | 'thinking' | 'running' | 'done'

const state = ref<State>('idle')
const typedPrompt = ref('')
const visibleIterations = ref<ToolCall[][]>([])
const bodyEl = ref<HTMLDivElement | null>(null)

function scrollToBottom() {
  const el = bodyEl.value
  if (!el) return
  el.scrollTo({ top: el.scrollHeight, behavior: 'smooth' })
}

watch(
  () => visibleIterations.value.map(i => i.length).join(','),
  () => { void nextTick(scrollToBottom) },
)
watch(state, () => { void nextTick(scrollToBottom) })

let timers: ReturnType<typeof setTimeout>[] = []
let nextId = 0

function wait(ms: number) {
  return new Promise<void>((resolve) => {
    const t = setTimeout(resolve, ms)
    timers.push(t)
  })
}

function clearTimers() {
  for (const t of timers) clearTimeout(t)
  timers = []
}

function reset() {
  clearTimers()
  typedPrompt.value = ''
  visibleIterations.value = []
  nextId = 0
}

async function typePrompt() {
  state.value = 'typing'
  for (let i = 0; i <= PROMPT.length; i++) {
    typedPrompt.value = PROMPT.slice(0, i)
    await wait(28 + Math.random() * 30)
  }
}

async function runIteration(def: IterationDef) {
  const iterIndex = visibleIterations.value.length
  visibleIterations.value.push([])

  for (const call of def.calls) {
    const entry: ToolCall = {
      ...call,
      id: ++nextId,
      status: 'running',
    }
    visibleIterations.value[iterIndex].push(entry)
    await wait(entry.durationMs)
    entry.status = call.result
    await wait(120)
  }
}

async function play() {
  if (state.value === 'typing' || state.value === 'running') return
  reset()

  await wait(200)
  await typePrompt()
  await wait(280)

  state.value = 'thinking'
  await wait(620)

  state.value = 'running'
  for (const iter of SCRIPT) {
    await runIteration(iter)
    await wait(220)
  }

  state.value = 'done'
}

onMounted(() => {
  const t = setTimeout(() => { void play() }, 350)
  timers.push(t)
})

onBeforeUnmount(() => {
  clearTimers()
})
</script>

<style scoped>
.agent-demo {
  font-family: 'Geist Mono', ui-monospace, monospace;
  border-radius: 12px;
  border: 1px solid rgba(255, 107, 237, 0.18);
  background: linear-gradient(135deg, rgba(255, 107, 237, 0.04) 0%, rgba(20, 22, 34, 0.7) 100%);
  box-shadow:
    0 0 0 1px rgba(255, 107, 237, 0.08),
    0 0 30px -4px rgba(255, 107, 237, 0.18),
    0 12px 40px -10px rgba(0, 0, 0, 0.5);
  overflow: hidden;
  color: rgba(234, 237, 243, 0.92);
  width: 100%;
  max-width: 820px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
}

.agent-demo__chrome {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 14px;
  background: rgba(8, 10, 18, 0.75);
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  font-size: 11px;
}

.agent-demo__dots {
  display: flex;
  gap: 5px;
}

.agent-demo__dots span {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.15);
}

.agent-demo__dots span:nth-child(1) { background: #ff5f57; }
.agent-demo__dots span:nth-child(2) { background: #febc2e; }
.agent-demo__dots span:nth-child(3) { background: #28c840; }

.agent-demo__title {
  flex: 1;
  text-align: center;
  opacity: 0.55;
  letter-spacing: 0.04em;
}

.agent-demo__replay {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-family: inherit;
  font-size: 11px;
  padding: 3px 8px;
  border-radius: 6px;
  background: rgba(255, 107, 237, 0.12);
  color: #ff6bed;
  border: 1px solid rgba(255, 107, 237, 0.25);
  cursor: pointer;
  transition: background 0.15s;
}

.agent-demo__replay:hover:not(:disabled) {
  background: rgba(255, 107, 237, 0.22);
}

.agent-demo__replay:disabled {
  opacity: 0.35;
  cursor: not-allowed;
}

.agent-demo__body {
  padding: 18px 20px 20px;
  font-size: 14px;
  line-height: 1.55;
  height: 440px;
  overflow-y: auto;
  scroll-behavior: smooth;
  scrollbar-width: thin;
  scrollbar-color: rgba(255, 107, 237, 0.25) transparent;
}

.agent-demo__body::-webkit-scrollbar {
  width: 6px;
}

.agent-demo__body::-webkit-scrollbar-track {
  background: transparent;
}

.agent-demo__body::-webkit-scrollbar-thumb {
  background: rgba(255, 107, 237, 0.2);
  border-radius: 3px;
}

.agent-demo__body::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 107, 237, 0.35);
}

.agent-demo__prompt-line {
  display: flex;
  align-items: baseline;
  gap: 10px;
  margin-bottom: 12px;
}

.agent-demo__chevron {
  color: #ff6bed;
  font-weight: bold;
}

.agent-demo__prompt {
  color: rgba(234, 237, 243, 0.98);
}

.agent-demo__caret {
  color: #ff6bed;
  animation: blink 1s infinite step-end;
  margin-left: 2px;
}

@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}

.agent-demo__thinking {
  display: flex;
  align-items: center;
  gap: 6px;
  margin: 6px 0 12px;
  font-size: 12px;
  color: rgba(234, 237, 243, 0.5);
}

.agent-demo__dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: #ff6bed;
  animation: pulse 1.2s infinite ease-in-out;
}

.agent-demo__dot:nth-child(2) { animation-delay: 0.2s; }
.agent-demo__dot:nth-child(3) { animation-delay: 0.4s; }

@keyframes pulse {
  0%, 100% { opacity: 0.3; transform: scale(0.7); }
  50% { opacity: 1; transform: scale(1); }
}

.agent-demo__thinking-label {
  margin-left: 4px;
  font-style: italic;
}

.agent-demo__iter {
  margin: 10px 0 4px;
}

.agent-demo__iter-label {
  display: flex;
  align-items: center;
  margin-bottom: 4px;
}

.agent-demo__iter-tag {
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: rgba(255, 107, 237, 0.6);
  padding: 2px 8px;
  border-radius: 4px;
  background: rgba(255, 107, 237, 0.08);
  border: 1px solid rgba(255, 107, 237, 0.15);
}

.agent-demo__calls {
  display: flex;
  flex-direction: column;
  gap: 3px;
  padding-left: 6px;
  border-left: 1px dashed rgba(255, 107, 237, 0.2);
  margin-left: 4px;
}

.agent-demo__call {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 3px 8px;
  font-size: 13px;
}

.agent-demo__tool {
  font-weight: 600;
  font-size: 12px;
  min-width: 76px;
  padding: 1px 6px;
  border-radius: 4px;
  text-align: center;
}

.tool-Read    { color: #7dd3fc; background: rgba(125, 211, 252, 0.12); }
.tool-Grep    { color: #c084fc; background: rgba(192, 132, 252, 0.12); }
.tool-Edit    { color: #ff6bed; background: rgba(255, 107, 237, 0.15); }
.tool-Bash    { color: #4ade80; background: rgba(74, 222, 128, 0.12); }
.tool-context7 { color: #fbbf24; background: rgba(251, 191, 36, 0.12); }

.agent-demo__args {
  flex: 1;
  opacity: 0.78;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.agent-demo__status {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
}

.agent-demo__spinner {
  width: 11px;
  height: 11px;
  border: 1.5px solid rgba(255, 107, 237, 0.25);
  border-top-color: #ff6bed;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.agent-demo__ok {
  color: #4ade80;
  width: 13px;
  height: 13px;
}

.agent-demo__fail {
  color: #f87171;
  width: 13px;
  height: 13px;
}

.agent-demo__duration {
  font-size: 11px;
  opacity: 0.5;
  min-width: 38px;
  text-align: right;
}

.agent-demo__duration--fail {
  color: #f87171;
  opacity: 0.75;
}

.agent-demo__done {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 14px;
  padding: 8px 12px;
  border-radius: 6px;
  background: rgba(74, 222, 128, 0.08);
  border: 1px solid rgba(74, 222, 128, 0.2);
  color: #86efac;
  font-size: 13px;
}

.agent-demo__done .i-ph-check-circle-fill {
  width: 16px;
  height: 16px;
}

.call-enter-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}
.call-enter-from {
  opacity: 0;
  transform: translateX(-8px);
}

.thinking-enter-active,
.thinking-leave-active {
  transition: opacity 0.25s ease;
}
.thinking-enter-from,
.thinking-leave-to {
  opacity: 0;
}
</style>
