# claude-p-sim.sh — condensed RE-ENACTMENT of a real `claude -p` print-mode run.
#
# Why a re-enactment: the real run is the workout-tracker QA from the deck —
# 70 turns, ~10m30s, driven by agent-browser against a live preview deploy.
# That is nondeterministic and far too long to capture in a slide clip, so this
# script streams a shortened version using the REAL numbers and the REAL two
# bugs that run found. Nothing here is invented; it is the same run, compressed.
#
# Sourced by claude-p.tape, which then types the genuine command. Defining a
# shell function named `claude` shadows the real binary for the recording only.
#
# Print mode (`claude -p`) has no REPL startup banner — that's the slide's whole
# point ("Claude Code without the chat UI") — so there's deliberately no
# cc_banner here. We still source cc-lib.sh for the one shared palette.

source ./cc-lib.sh

claude() {
  printf "\n"
  sleep 0.5
  printf "${PINK}●${RST} I'll test the preview like a QA engineer — walk every\n"
  printf "  acceptance criterion against the live app, then explore beyond them.\n\n"
  sleep 0.9

  printf "${PINK}●${RST} ${BOLD}Bash${RST}(agent-browser open https://workout-tracker-pr142.preview…)\n"
  sleep 0.5
  printf "  ${DIM}⎿ Loaded preview in real Chromium${RST}\n\n"
  sleep 0.7

  printf "${PINK}●${RST} ${BOLD}Bash${RST}(agent-browser snapshot -i)\n"
  sleep 0.5
  printf "  ${DIM}⎿ Read interactive a11y tree — refs resolved${RST}\n\n"
  sleep 0.7

  printf "  ${DIM}… click · fill · console · snapshot again …  70 turns · ~10m30s${RST}\n\n"
  sleep 1.2

  printf "${PINK}●${RST} Acceptance criteria: ${GREEN}7/7 verified against the live app ✓${RST}\n\n"
  sleep 0.9

  printf "${PINK}●${RST} Beyond the ticket — ${BOLD}2 genuine bugs${RST} (neither in the ACs):\n"
  sleep 0.4
  printf "    • copy:  \"with 0 blocks\" when the template has one\n"
  sleep 0.4
  printf "    • a11y:  rest timer missing role=\"timer\"\n\n"
  sleep 1.0

  printf "${PINK}●${RST} Wrote ${BOLD}qa-report.md${RST} + machine-readable ${BOLD}verdict.json${RST}\n\n"
  sleep 0.6
}
