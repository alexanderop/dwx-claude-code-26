<script setup lang="ts">
const { href, label = 'Source' } = defineProps<{
  /** The URL to display, e.g. "alexop.dev/posts/my-post" */
  href: string
  /** Small leading tag, defaults to "Source" */
  label?: string
}>()
</script>

<template>
  <div class="source-ref">
    <div class="i-carbon-link source-ref__icon" />
    <span class="source-ref__label">{{ label }}</span>
    <span class="source-ref__divider" />
    <span class="source-ref__url">{{ href }}</span>
  </div>
</template>

<style scoped>
.source-ref {
  position: absolute;
  bottom: 2.4rem;
  right: 1.5rem;
  z-index: 20;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.3rem 0.75rem;
  border-radius: 9999px;
  background: rgba(255, 107, 237, 0.07);
  border: 1px solid rgba(255, 107, 237, 0.2);
  box-shadow: 0 2px 12px -6px rgba(255, 107, 237, 0.25);
  backdrop-filter: blur(4px);
  line-height: 1;
}

.source-ref__icon {
  width: 0.85rem;
  height: 0.85rem;
  color: #ff6bed;
  flex-shrink: 0;
}

.source-ref__label {
  font-size: 0.62rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: #ff6bed;
}

.source-ref__divider {
  width: 1px;
  height: 0.8rem;
  background: rgba(255, 107, 237, 0.25);
}

.source-ref__url {
  font-family: 'Geist Mono', monospace;
  font-size: 0.72rem;
  color: rgba(234, 237, 243, 0.85);
  white-space: nowrap;
}
</style>
