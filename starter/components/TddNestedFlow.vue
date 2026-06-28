<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{ step?: number }>(), { step: 0 })

// Current click. Steps:
//  0  user prompt sits in your context (resting state)
//  1  delegate ▸ orchestrator container appears (empty)
//  2  AC1 runs RED → GREEN → REFACTOR
//  3  AC2 + AC3 loop the same shape
//  4  one summary returns; counters land
const cur = computed(() => props.step ?? 0)
const show = (n: number) => (cur.value >= n ? 1 : 0)
const grp = (n: number) => ({ opacity: show(n), transition: 'opacity .45s ease' })

// the three nested r/g/r phases — labelled once (AC1), colour-coded everywhere
const phases = [
  { label: 'RED', variant: 'danger' as const, x: 470, w: 84 },
  { label: 'GREEN', variant: 'success' as const, x: 596, w: 96 },
  { label: 'REFACTOR', variant: 'accent' as const, x: 730, w: 116 },
]

// acceptance-criterion rows inside the orchestrator
const rows = [
  { id: 'AC1', y: 98, at: 2 },
  { id: 'AC2', y: 160, at: 3 },
  { id: 'AC3', y: 222, at: 3 },
]

const boxH = 42
const mid = (y: number) => y + boxH / 2
</script>

<template>
  <div class="tdd-nested">
    <RoughSvg :width="920" :height="372" :roughness="1.3" :seed="42">
      <!-- ── lane titles + divider (always on) ── -->
      <RoughText :x="165" :y="14" variant="title">your context</RoughText>
      <RoughText :x="648" :y="14" variant="title">two levels down</RoughText>
      <RoughLine :x1="350" :y1="32" :x2="350" :y2="322" stroke="rgba(255,255,255,0.18)" :stroke-dasharray="'5 6'" />

      <!-- ── LEFT: your context window ── -->
      <!-- step 0: the prompt -->
      <g :style="grp(0)">
        <RoughRect :x="24" :y="42" :width="282" :height="64" variant="muted" />
        <RoughText :x="165" :y="66" variant="label">build Set Logger</RoughText>
        <RoughText :x="165" :y="88" variant="subtitle">you · 3 acceptance criteria · TDD</RoughText>
      </g>

      <!-- step 4: the answer + the count -->
      <g :style="grp(4)">
        <RoughRect :x="24" :y="238" :width="282" :height="64" variant="success" />
        <RoughText :x="165" :y="262" variant="label">done · 3/3 green</RoughText>
        <RoughText :x="165" :y="284" variant="subtitle">9 tests, all passing</RoughText>
        <RoughText :x="165" :y="328" variant="detail">2 messages — the 9 turns never touched it</RoughText>
      </g>

      <!-- ── cross-lane arrows: the only two things that cross ── -->
      <g :style="grp(1)">
        <RoughArrow :x1="306" :y1="74" :x2="392" :y2="60" :arrow-size="11" />
        <RoughText :x="332" :y="46" variant="edgeLabel">delegate ▸</RoughText>
      </g>
      <g :style="grp(4)">
        <RoughArrow :x1="392" :y1="296" :x2="306" :y2="278" :arrow-size="11" stroke="rgba(52,211,153,0.7)" />
        <RoughText :x="342" :y="300" variant="edgeLabel">◂ 1 summary</RoughText>
      </g>

      <!-- ── RIGHT: the nested orchestrator ── -->
      <g :style="grp(1)">
        <RoughRect :x="388" :y="36" :width="512" :height="276" variant="default" fill-style="hachure" :fill="'rgba(255,107,237,0.04)'" />
        <RoughText :x="404" :y="56" variant="edgeLabel" text-anchor="start">tdd-orchestrator</RoughText>
        <RoughText :x="884" :y="56" variant="subtitle" text-anchor="end">fresh context · sealed</RoughText>
      </g>

      <!-- AC rows: RED → GREEN → REFACTOR -->
      <g v-for="row in rows" :key="row.id" :style="grp(row.at)">
        <RoughText :x="404" :y="mid(row.y)" variant="detail" text-anchor="start">{{ row.id }}</RoughText>
        <template v-for="(p, i) in phases" :key="p.label">
          <RoughRect :x="p.x" :y="row.y" :width="p.w" :height="boxH" :variant="p.variant" />
          <!-- label the pattern once, on AC1 -->
          <RoughText v-if="row.at === 2" :x="p.x + p.w / 2" :y="mid(row.y)" variant="detail">{{ p.label }}</RoughText>
          <RoughArrow
            v-if="i < phases.length - 1"
            :x1="p.x + p.w + 4"
            :y1="mid(row.y)"
            :x2="phases[i + 1].x - 4"
            :y2="mid(row.y)"
            :arrow-size="9"
          />
        </template>
      </g>

      <!-- legend: name the agents once, inside the box -->
      <g :style="grp(3)">
        <RoughText :x="404" :y="292" variant="subtitle" text-anchor="start">red test-writer · green implementer · refactor refactorer</RoughText>
      </g>
    </RoughSvg>
  </div>
</template>

<style scoped>
.tdd-nested {
  margin-top: 0.5rem;
  width: 100%;
  display: flex;
  justify-content: center;
}
</style>
