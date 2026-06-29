# subtree-sim.sh — condensed RE-ENACTMENT of asking Claude to implement a feature
# AFTER vendoring VueUse as a subtree (the `git subtree add repos/vueuse` slide).
#
# Why a re-enactment: the real run reads several files in repos/vueuse and writes
# a composable — too long and nondeterministic for a slide clip. This streams a
# shortened, truthful version: the agent reads the REAL VueUse composables it
# would actually open (useIntervalFn, useDocumentVisibility), then mirrors their
# REAL API shape (pause/resume/isActive controls, MaybeRefOrGetter + toValue,
# tryOnScopeDispose cleanup). Nothing here is invented; it is that run, compressed.
#
# Sourced by subtree.tape, which then types the genuine prompt. Defining a shell
# function named `claude` shadows the real binary for the recording only.
# Palette + the shared Claude Code banner come from cc-lib.sh.

source ./cc-lib.sh

claude() {
  cc_banner "~/workout-tracker"
  cc_prompt              # the tape types the feature request into this read, live
  sleep 0.6

  printf "${PINK}●${RST} I won't guess the API — I'll read how VueUse does it first,\n"
  printf "  then mirror that shape.\n\n"
  sleep 0.9

  printf "${PINK}●${RST} ${BOLD}Grep${RST}(useIntervalFn) in ${DIM}repos/vueuse${RST}\n"
  sleep 0.5
  printf "  ${DIM}⎿ packages/shared/useIntervalFn/index.ts${RST}\n\n"
  sleep 0.7

  printf "${PINK}●${RST} ${BOLD}Read${RST}(repos/vueuse/.../useIntervalFn/index.ts)\n"
  sleep 0.5
  printf "  ${DIM}⎿ returns { isActive, pause, resume } · MaybeRefOrGetter + toValue${RST}\n\n"
  sleep 0.7

  printf "${PINK}●${RST} ${BOLD}Read${RST}(repos/vueuse/.../useDocumentVisibility/index.ts)\n"
  sleep 0.5
  printf "  ${DIM}⎿ visibility ref drives pause/resume — no manual listeners${RST}\n\n"
  sleep 0.9

  printf "${PINK}●${RST} Wrote ${BOLD}src/composables/useRestTimer.ts${RST} — mirrors the library:\n"
  sleep 0.4
  printf "    • controls ${BOLD}{ isActive, pause, resume }${RST} — same as useIntervalFn\n"
  sleep 0.4
  printf "    • ${BOLD}MaybeRefOrGetter<number>${RST} + ${BOLD}toValue${RST} for the duration\n"
  sleep 0.4
  printf "    • ${BOLD}tryOnScopeDispose${RST} cleanup — no hand-rolled onUnmounted\n\n"
  sleep 1.0

  printf "${GREEN}●${RST} ${BOLD}Done.${RST} No new deps. Reads like it was lifted from VueUse.\n\n"
  sleep 0.6
}
