<script setup lang="ts">
import { onMounted } from 'vue'
import { useDarkMode } from '@slidev/client'

// colorSchema is 'auto' so the opener joke can flip the theme live.
// Force dark on load so the deck always opens dark, even on a light-mode
// laptop. The live toggle during the joke happens after this, so it still works.
const { isDark } = useDarkMode()

onMounted(() => {
  isDark.value = true
})
</script>

<template>
  <div />
</template>
