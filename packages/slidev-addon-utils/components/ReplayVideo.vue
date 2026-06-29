<script setup lang="ts">
import { ref } from 'vue'

const { src, poster } = defineProps<{
  /** Video source, e.g. "/context.webm" */
  src: string
  /** Optional poster image shown before/after playback */
  poster?: string
}>()

const video = ref<HTMLVideoElement>()

function replay() {
  const el = video.value
  if (!el) return
  el.currentTime = 0
  el.play()
}
</script>

<template>
  <div class="replay-video" @click="replay">
    <video
      ref="video"
      :src="src"
      :poster="poster"
      autoplay
      muted
      playsinline
      class="w-full block"
    />
    <div class="replay-video__hint">
      <div class="i-carbon-restart" />
      <span>Click to replay</span>
    </div>
  </div>
</template>

<style scoped>
.replay-video {
  position: relative;
  cursor: pointer;
}

.replay-video__hint {
  position: absolute;
  bottom: 0.6rem;
  right: 0.6rem;
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.25rem 0.6rem;
  border-radius: 9999px;
  background: rgba(0, 0, 0, 0.55);
  border: 1px solid rgba(255, 107, 237, 0.25);
  color: rgba(234, 237, 243, 0.9);
  font-size: 0.65rem;
  line-height: 1;
  opacity: 0;
  transition: opacity 0.15s ease;
  pointer-events: none;
}

.replay-video:hover .replay-video__hint {
  opacity: 1;
}

.replay-video__hint > div {
  width: 0.8rem;
  height: 0.8rem;
  color: #ff6bed;
}
</style>
