<script setup lang="ts">
import { computed } from 'vue'

type TalkCard = {
  body?: string
  dashed?: boolean
  eyebrow?: string
  glow?: boolean
  icon?: string
  title?: string
  value?: string
  variant?: 'default' | 'muted' | 'success'
}

const props = withDefaults(defineProps<{
  cards: TalkCard[]
  columns?: 1 | 2 | 3
  compact?: boolean
  maxWidth?: string
}>(), {
  columns: 3,
  compact: false,
  maxWidth: 'max-w-5xl',
})

const gridClass = computed(() => [
  'grid',
  props.columns === 1 ? 'grid-cols-1' : props.columns === 2 ? 'grid-cols-2' : 'grid-cols-3',
  props.compact ? 'gap-2' : 'gap-6',
  props.maxWidth,
  'mx-auto',
])
</script>

<template>
  <div :class="gridClass">
    <Card
      v-for="card in cards"
      :key="`${card.eyebrow ?? ''}-${card.title ?? card.body ?? ''}`"
      :variant="card.variant"
      :glow="card.glow"
      :dashed="card.dashed"
      :size="compact ? 'sm' : 'md'"
    >
      <div v-if="card.icon" class="text-3xl mb-2">{{ card.icon }}</div>
      <div v-if="card.eyebrow" class="text-xs op-60 mb-1" v-html="card.eyebrow" />
      <div v-if="card.title" class="font-bold mb-1 talk-card-grid__title" v-html="card.title" />
      <div v-if="card.value" class="text-3xl font-bold mb-1 talk-card-grid__value" v-html="card.value" />
      <div v-if="card.body" class="text-xs op-75" v-html="card.body" />
    </Card>
  </div>
</template>

<style scoped>
.talk-card-grid__title {
  color: #ff6bed;
  font-size: 1.125rem;
  line-height: 1.35;
}

.talk-card-grid__value {
  color: #ff6bed;
  line-height: 1.2;
}
</style>
