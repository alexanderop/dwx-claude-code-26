<template>
  <div class="phone-frame-stage">
    <div class="phone-frame">
      <!-- Side buttons -->
      <span class="phone-btn phone-btn-silence" />
      <span class="phone-btn phone-btn-vol-up" />
      <span class="phone-btn phone-btn-vol-down" />
      <span class="phone-btn phone-btn-power" />

      <!-- Screen -->
      <div class="phone-screen">
        <!-- Dynamic island / notch -->
        <div class="phone-island" />

        <iframe
          class="phone-iframe"
          :src="url"
          :title="title"
          loading="lazy"
          allow="fullscreen"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { url, title = 'Mobile app preview' } = defineProps<{
  url: string
  title?: string
}>()
</script>

<style scoped>
.phone-frame-stage {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Device shell */
.phone-frame {
  position: relative;
  height: 86%;
  aspect-ratio: 9 / 19.5;
  border-radius: 44px;
  padding: 11px;
  background: linear-gradient(150deg, #2b2b30 0%, #0d0d10 45%, #1a1a1e 100%);
  box-shadow:
    inset 0 0 2px 2px rgba(255, 255, 255, 0.08),
    0 0 0 2px #000,
    0 30px 60px -15px rgba(0, 0, 0, 0.7),
    0 0 70px -20px rgba(255, 107, 237, 0.25);
}

/* Screen + content */
.phone-screen {
  position: relative;
  height: 100%;
  width: 100%;
  border-radius: 34px;
  overflow: hidden;
  background: #000;
}

.phone-iframe {
  /* Render the iframe at a wider logical viewport, then scale it down to
     fit the physical screen. This gives the mobile layout more width so
     content (day labels, action cards) stops overlapping. */
  --zoom: 0.6;
  width: calc(100% / var(--zoom));
  height: calc(100% / var(--zoom));
  transform: scale(var(--zoom));
  transform-origin: top left;
  border: 0;
  display: block;
  background: #0a0a0a;
}

/* Dynamic island */
.phone-island {
  position: absolute;
  top: 12px;
  left: 50%;
  transform: translateX(-50%);
  width: 32%;
  height: 26px;
  background: #000;
  border-radius: 16px;
  z-index: 2;
  pointer-events: none;
}

/* Side buttons */
.phone-btn {
  position: absolute;
  background: linear-gradient(180deg, #3a3a40, #18181c);
  border-radius: 2px;
}
.phone-btn-silence {
  left: -2px;
  top: 17%;
  width: 3px;
  height: 26px;
}
.phone-btn-vol-up {
  left: -2px;
  top: 24%;
  width: 3px;
  height: 52px;
}
.phone-btn-vol-down {
  left: -2px;
  top: 35%;
  width: 3px;
  height: 52px;
}
.phone-btn-power {
  right: -2px;
  top: 27%;
  width: 3px;
  height: 70px;
}
</style>
