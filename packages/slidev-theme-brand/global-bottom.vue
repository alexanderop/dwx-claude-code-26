<script setup lang="ts">
import { computed } from 'vue'
import { useNav } from '@slidev/client'
import LayoutFooter from './components/LayoutFooter.vue'

const { currentSlideRoute } = useNav()

const hideFooter = computed(
  () => currentSlideRoute.value?.meta?.slide?.frontmatter?.hideFooter === true,
)
</script>

<template>
  <LayoutFooter v-if="!hideFooter" />
</template>
