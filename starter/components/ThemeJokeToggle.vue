<script setup lang="ts">
import { useDarkMode } from '@slidev/client'

const { isDark, toggleDark } = useDarkMode()
</script>

<template>
  <div class="theme-joke-toggle">
    <button
      class="seg"
      :class="{ light: !isDark }"
      type="button"
      role="switch"
      :aria-checked="isDark"
      aria-label="Toggle slide theme between light and dark"
      @click="toggleDark()"
    >
      <span class="thumb" :class="{ right: isDark }" />
      <span class="opt" :class="{ active: !isDark }">
        <span class="ico">☀️</span> Light
      </span>
      <span class="opt" :class="{ active: isDark }">
        <span class="ico">🌙</span> Dark
      </span>
    </button>

    <div class="hint">
      <span v-if="isDark">Good choice. Let's keep it dark. 🖤</span>
      <span v-else>Bold. My retinas are fine, thanks for asking. 🥲</span>
    </div>
  </div>
</template>

<style scoped>
.theme-joke-toggle {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.25rem;
}

.seg {
  position: relative;
  display: grid;
  grid-template-columns: 1fr 1fr;
  align-items: center;
  width: 22rem;
  padding: 0.4rem;
  border-radius: 9999px;
  border: 2px solid var(--brand-border);
  background: var(--brand-card);
  cursor: pointer;
  user-select: none;
  transition: background 0.3s ease, border-color 0.3s ease;
}

.thumb {
  position: absolute;
  top: 0.4rem;
  bottom: 0.4rem;
  left: 0.4rem;
  width: calc(50% - 0.4rem);
  border-radius: 9999px;
  background: var(--brand-accent);
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.thumb.right {
  transform: translateX(100%);
}

.opt {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.7rem 1rem;
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--brand-text);
  opacity: 0.55;
  transition: opacity 0.3s ease, color 0.3s ease;
}

.opt.active {
  opacity: 1;
  color: var(--brand-bg);
}

.ico {
  font-size: 1.35rem;
  line-height: 1;
}

.hint {
  font-size: 1rem;
  opacity: 0.7;
  min-height: 1.5rem;
}
</style>
