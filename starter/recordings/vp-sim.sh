# vp-sim.sh — illustrative re-enactment of the Vite+ unified CLI on the workout
# tracker. The subcommands (vp check / test / build) and what they do are REAL
# (vp check = format + lint + type checks); the file/test counts and timings are
# representative, not captured. The point of the slide is "one CLI, and it's
# fast" — that claim is true; these numbers just make it legible.
#
# Sourced by vp-tape.tape, which then types the genuine `vp …` commands. The
# `vp` shell function below shadows the real binary for the recording only.

PINK='\033[38;2;255;107;237m'
DIM='\033[2m'
GREEN='\033[32m'
BOLD='\033[1m'
RST='\033[0m'
OK="${GREEN}✓${RST}"

vp() {
  case "$1" in
    check)
      printf "\n"
      sleep 0.3
      printf "  ${OK} ${BOLD}format${RST}  ${DIM}oxfmt${RST}    284 files, no changes        ${DIM}0.3s${RST}\n"
      sleep 0.35
      printf "  ${OK} ${BOLD}lint${RST}    ${DIM}oxlint${RST}   284 files, 0 problems        ${DIM}0.5s${RST}\n"
      sleep 0.35
      printf "  ${OK} ${BOLD}types${RST}   ${DIM}vue-tsc${RST}  0 errors                     ${DIM}2.0s${RST}\n"
      sleep 0.4
      printf "  ${GREEN}${BOLD}check passed${RST} ${DIM}in 2.8s${RST}\n\n"
      sleep 0.5
      ;;
    test)
      printf "\n"
      sleep 0.3
      printf "  ${OK} ${BOLD}vitest${RST}  6 files · 52 tests · ${GREEN}all passed${RST}      ${DIM}1.6s${RST}\n\n"
      sleep 0.6
      ;;
    build)
      printf "\n"
      sleep 0.3
      printf "  ${DIM}rolldown${RST} bundling…\n"
      sleep 0.5
      printf "  dist/assets/index-${DIM}a1b2c3${RST}.js   58.2 kB ${DIM}│ gzip 21.4 kB${RST}\n"
      sleep 0.3
      printf "  dist/assets/vendor-${DIM}d4e5f6${RST}.js  102.7 kB ${DIM}│ gzip 38.1 kB${RST}\n"
      sleep 0.35
      printf "  ${OK} ${BOLD}built${RST} 214 modules → ${BOLD}dist/${RST} ${DIM}in 0.42s${RST}\n\n"
      sleep 0.6
      ;;
  esac
}
