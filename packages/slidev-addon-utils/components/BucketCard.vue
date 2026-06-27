<script setup lang="ts">
import { computed } from 'vue'

type ColorTheme = 'purple' | 'blue' | 'teal'
type TopIcon = 'document' | 'chat' | 'search'
type FooterIcon = 'document' | 'refresh' | 'sitemap'

const { number, color, title, question, footerText, topIcon, footerIcon } = defineProps<{
  number: string
  color: ColorTheme
  title: string
  question: string
  footerText: string
  topIcon: TopIcon
  footerIcon: FooterIcon
}>()

const palette = {
  purple: {
    light: '#d8b4fe',
    base: '#a855f7',
    dark: '#7c3aed',
    darker: '#4c1d95',
    rim: '#581c87',
    text: '#c4a5fc',
    border: 'rgba(168, 85, 247, 0.35)',
    borderSoft: 'rgba(168, 85, 247, 0.18)',
    glow: 'rgba(168, 85, 247, 0.22)',
  },
  blue: {
    light: '#93c5fd',
    base: '#3b82f6',
    dark: '#1d4ed8',
    darker: '#1e3a8a',
    rim: '#1e3a8a',
    text: '#93c5fd',
    border: 'rgba(59, 130, 246, 0.4)',
    borderSoft: 'rgba(59, 130, 246, 0.18)',
    glow: 'rgba(59, 130, 246, 0.22)',
  },
  teal: {
    light: '#5eead4',
    base: '#14b8a6',
    dark: '#0d9488',
    darker: '#134e4a',
    rim: '#134e4a',
    text: '#5eead4',
    border: 'rgba(20, 184, 166, 0.4)',
    borderSoft: 'rgba(20, 184, 166, 0.18)',
    glow: 'rgba(20, 184, 166, 0.22)',
  },
} as const

const theme = computed(() => palette[color])

const cardStyle = computed(() => ({
  background: 'linear-gradient(160deg, rgba(20, 20, 28, 0.6) 0%, rgba(10, 10, 18, 0.85) 100%)',
  borderColor: theme.value.borderSoft,
  boxShadow: `
    0 0 0 1px ${theme.value.borderSoft},
    0 0 24px -4px ${theme.value.glow},
    inset 0 1px 0 0 rgba(255, 255, 255, 0.04)
  `,
}))

const dividerStyle = computed(() => ({
  background: `linear-gradient(90deg, transparent 0%, ${theme.value.base} 50%, transparent 100%)`,
}))

const uid = computed(() => `${color}-${topIcon}`)
</script>

<template>
  <div class="bucket-card" :style="cardStyle">
    <div class="bucket-card__art">
      <svg viewBox="0 0 220 200" class="bucket-card__svg" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient :id="`body-${uid}`" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" :stop-color="theme.light" />
            <stop offset="50%" :stop-color="theme.base" />
            <stop offset="100%" :stop-color="theme.dark" />
          </linearGradient>
          <linearGradient :id="`rim-${uid}`" x1="0%" y1="0%" x2="0%" y2="100%">
            <stop offset="0%" :stop-color="theme.dark" />
            <stop offset="100%" :stop-color="theme.base" />
          </linearGradient>
          <linearGradient :id="`handle-${uid}`" x1="0%" y1="0%" x2="0%" y2="100%">
            <stop offset="0%" stop-color="#e2e8f0" />
            <stop offset="100%" stop-color="#94a3b8" />
          </linearGradient>
          <radialGradient :id="`glow-${uid}`" cx="50%" cy="50%" r="50%">
            <stop offset="0%" :stop-color="theme.base" stop-opacity="0.45" />
            <stop offset="100%" :stop-color="theme.base" stop-opacity="0" />
          </radialGradient>
        </defs>

        <!-- Soft glow under bucket -->
        <ellipse cx="110" cy="185" rx="70" ry="10" :fill="`url(#glow-${uid})`" />

        <!-- Handle (behind icon, in front of body top) -->
        <path
          d="M 58 78 Q 110 18 162 78"
          :stroke="`url(#handle-${uid})`"
          stroke-width="3"
          fill="none"
          stroke-linecap="round"
        />

        <!-- Bucket body (trapezoid) -->
        <path
          d="M 52 82
             L 70 175
             Q 72 182, 80 182
             L 140 182
             Q 148 182, 150 175
             L 168 82
             Z"
          :fill="`url(#body-${uid})`"
        />

        <!-- Left side highlight -->
        <path
          d="M 60 92 L 76 172"
          stroke="rgba(255,255,255,0.35)"
          stroke-width="2.5"
          stroke-linecap="round"
        />

        <!-- Right side shadow -->
        <path
          d="M 160 92 L 144 172"
          stroke="rgba(0,0,0,0.18)"
          stroke-width="3"
          stroke-linecap="round"
        />

        <!-- Top rim outer -->
        <ellipse cx="110" cy="82" rx="58" ry="10" :fill="`url(#rim-${uid})`" />

        <!-- Top inner opening (darker) -->
        <ellipse cx="110" cy="82" rx="50" ry="7" :fill="theme.rim" opacity="0.85" />

        <!-- Inner top highlight -->
        <ellipse cx="110" cy="79" rx="48" ry="2.5" fill="rgba(0,0,0,0.35)" />

        <!-- Top icon (emerging from bucket) -->
        <g v-if="topIcon === 'document'" transform="translate(110, 55)">
          <g transform="translate(-22, -38)">
            <path
              d="M 0 4 Q 0 0, 4 0 L 28 0 L 44 14 L 44 50 Q 44 54, 40 54 L 4 54 Q 0 54, 0 50 Z"
              :fill="theme.light"
            />
            <path d="M 28 0 L 28 14 L 44 14 Z" :fill="theme.base" opacity="0.7" />
            <line x1="8" y1="24" x2="36" y2="24" :stroke="theme.dark" stroke-width="2" stroke-linecap="round" />
            <line x1="8" y1="32" x2="36" y2="32" :stroke="theme.dark" stroke-width="2" stroke-linecap="round" />
            <line x1="8" y1="40" x2="28" y2="40" :stroke="theme.dark" stroke-width="2" stroke-linecap="round" />
          </g>
        </g>

        <g v-else-if="topIcon === 'chat'" transform="translate(110, 50)">
          <g transform="translate(-26, -32)">
            <path
              d="M 6 0 L 46 0 Q 52 0, 52 6 L 52 38 Q 52 44, 46 44 L 32 44 L 24 54 L 22 44 L 6 44 Q 0 44, 0 38 L 0 6 Q 0 0, 6 0 Z"
              :fill="theme.light"
            />
            <circle cx="14" cy="22" r="3" :fill="theme.dark" />
            <circle cx="26" cy="22" r="3" :fill="theme.dark" />
            <circle cx="38" cy="22" r="3" :fill="theme.dark" />
          </g>
        </g>

        <g v-else-if="topIcon === 'search'" transform="translate(110, 50)">
          <g transform="translate(-22, -30)">
            <circle cx="20" cy="20" r="16" fill="none" :stroke="theme.light" stroke-width="5" />
            <circle cx="20" cy="20" r="10" :fill="theme.base" opacity="0.25" />
            <line
              x1="32"
              y1="32"
              x2="46"
              y2="46"
              :stroke="theme.light"
              stroke-width="5"
              stroke-linecap="round"
            />
          </g>
        </g>
      </svg>
    </div>

    <div class="bucket-card__heading">
      <div class="bucket-card__number" :style="{ color: theme.base, borderColor: theme.border }">
        {{ number }}
      </div>
      <div class="bucket-card__title">{{ title }}</div>
    </div>

    <div class="bucket-card__divider" :style="dividerStyle" />

    <div class="bucket-card__question">{{ question }}</div>

    <div class="bucket-card__footer">
      <svg class="bucket-card__footer-icon" viewBox="0 0 24 24" fill="none" :style="{ color: theme.text }">
        <g v-if="footerIcon === 'document'" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M14 3 H6 a2 2 0 0 0 -2 2 v14 a2 2 0 0 0 2 2 h12 a2 2 0 0 0 2 -2 V9 z" />
          <path d="M14 3 v6 h6" />
          <line x1="8" y1="14" x2="16" y2="14" />
          <line x1="8" y1="18" x2="13" y2="18" />
        </g>
        <g v-else-if="footerIcon === 'refresh'" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M21 12 a9 9 0 0 1 -15.4 6.3" />
          <path d="M3 12 a9 9 0 0 1 15.4 -6.3" />
          <polyline points="17 4 18.4 5.7 16.7 7.1" />
          <polyline points="7 20 5.6 18.3 7.3 16.9" />
        </g>
        <g v-else-if="footerIcon === 'sitemap'" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
          <rect x="9" y="3" width="6" height="5" rx="1" />
          <rect x="3" y="16" width="6" height="5" rx="1" />
          <rect x="15" y="16" width="6" height="5" rx="1" />
          <path d="M12 8 v4" />
          <path d="M6 16 v-2 h12 v2" />
        </g>
      </svg>
      <div class="bucket-card__footer-text">{{ footerText }}</div>
    </div>
  </div>
</template>

<style scoped>
.bucket-card {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 18px 22px 22px;
  border-radius: 16px;
  border: 1px solid;
  height: 100%;
  backdrop-filter: blur(6px);
}

.bucket-card__art {
  width: 130px;
  height: 130px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 4px;
}

.bucket-card__svg {
  width: 100%;
  height: 100%;
  overflow: visible;
}

.bucket-card__heading {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 10px;
}

.bucket-card__number {
  font-family: 'Geist Mono', monospace;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.04em;
  width: 28px;
  height: 28px;
  border-radius: 999px;
  border: 1px solid;
  display: flex;
  align-items: center;
  justify-content: center;
}

.bucket-card__title {
  font-family: 'Geist', sans-serif;
  font-size: 22px;
  font-weight: 700;
  color: rgba(234, 237, 243, 0.98);
  letter-spacing: -0.01em;
}

.bucket-card__divider {
  width: 60%;
  height: 1px;
  margin-bottom: 14px;
  opacity: 0.8;
}

.bucket-card__question {
  font-family: 'Geist', sans-serif;
  font-size: 14px;
  text-align: center;
  color: rgba(234, 237, 243, 0.85);
  line-height: 1.45;
  margin-bottom: 18px;
  max-width: 220px;
}

.bucket-card__footer {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  margin-top: auto;
  padding-top: 8px;
  width: 100%;
}

.bucket-card__footer-icon {
  width: 22px;
  height: 22px;
  flex-shrink: 0;
  margin-top: 2px;
}

.bucket-card__footer-text {
  font-family: 'Geist', sans-serif;
  font-size: 12.5px;
  line-height: 1.5;
  color: rgba(234, 237, 243, 0.7);
}
</style>
