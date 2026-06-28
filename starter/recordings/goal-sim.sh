# goal-sim.sh — condensed re-enactment of `/goal raise coverage by +5` on the
# workout tracker. The loop's behaviour is REAL and matches the slide: each turn
# writes tests, runs `pnpm test:coverage`, a fast model checks whether the target
# is met, and sends Claude back in with the reason until it clears. The specific
# coverage numbers are representative, not captured — they exist to make the
# "self-checking finish line" visible. The baseline + target (+5) are the point.
#
# Sourced by goal.tape. `claude` shadows the real binary for the recording only:
# it prints a minimal REPL prompt, reads the slash command the tape types live,
# then streams the self-checking iterations.

PINK='\033[38;2;255;107;237m'
DIM='\033[2m'
GREEN='\033[32m'
BLUE='\033[38;2;120;170;255m'
BOLD='\033[1m'
RST='\033[0m'

# one iteration: $1 = turn label, $2 = new coverage, $3 = checker verdict line
turn() {
  printf "${PINK}●${RST} ${BOLD}$1${RST} — wrote tests, ran ${DIM}pnpm test:coverage${RST}\n"
  sleep 0.5
  printf "  coverage: ${BOLD}$2%%${RST}\n"
  sleep 0.5
  printf "  ${BLUE}↳ check${RST} $3\n\n"
  sleep 0.7
}

# Numbers align with the real receipts on the next slide (goal-coverage-complete.png:
# the +5 lift cleared on STATEMENTS, ending 86.23%; ~47 min; zero "continue").
# This clip shows the JOURNEY to that number; the screenshot is the proof.
claude() {
  printf "  ${DIM}Claude Code — interactive. Try \"/goal …\".${RST}\n"
  printf "${PINK}❯${RST} "
  read -r _cmd          # the tape types the /goal command into this read, live
  printf "\n"
  sleep 0.5
  printf "  ${DIM}statement coverage baseline: 81.2%% · target: ≥ 86.2%% (+5)${RST}\n\n"
  sleep 0.8
  turn "turn 1" "82.9" "+1.7 so far — not there yet, continue"
  turn "turn 2" "84.7" "+3.5 — closer, keep going"
  turn "turn 3" "86.2" "${GREEN}+5.0 ≥ +5 — goal cleared ✓${RST}"
  sleep 0.2
  printf "${GREEN}●${RST} ${BOLD}Done.${RST} Statement coverage 81.2%% → ${BOLD}86.2%%${RST}. Only test files changed.\n"
  printf "  ${DIM}~47 min away from the keyboard · zero \"continue\" from me.${RST}\n\n"
  sleep 0.6
}
