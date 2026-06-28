<script setup lang="ts">
withDefaults(defineProps<{
  alt?: string
  contain?: boolean
  maxHeight?: string
  rounded?: boolean
  shadow?: boolean
  src: string
}>(), {
  alt: '',
  contain: false,
  maxHeight: '85vh',
  rounded: true,
  shadow: true,
})
</script>

<template>
  <div class="h-full flex items-center justify-center">
    <img
      :src="src"
      :alt="alt"
      class="max-w-full w-auto"
      :class="{
        'max-h-full': contain,
        'rounded-lg': rounded,
        'shadow-lg': shadow,
      }"
      :style="contain ? undefined : { maxHeight }"
    />
  </div>
</template>
