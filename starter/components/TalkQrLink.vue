<script setup lang="ts">
const props = withDefaults(defineProps<{
  image: string
  label?: string
  small?: boolean
}>(), {
  label: '',
  small: false,
})
</script>

<template>
  <div class="flex flex-col items-center gap-1">
    <img
      :src="props.image"
      class="bg-white rounded"
      :class="props.small ? 'w-20 h-20 p-1.5' : 'w-44 h-44 p-2 rounded-lg'"
    />
    <div
      v-if="props.label"
      class="op-70 text-center"
      :class="props.small ? 'text-[10px] op-50' : 'text-xs max-w-44'"
      style="color: #ff6bed"
      v-html="props.label"
    />
  </div>
</template>
