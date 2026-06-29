# context-sim.sh — re-enactment shim for the `/context` slide.
#
# Reproduces the Claude Code `/context` output (Context Usage grid + "Estimated
# usage by category") from Alex's real screenshots: v2.1.195, Opus 4.8 (1M
# context), 25.5k/1m tokens (3%). Sourced (not recorded) by context.tape.
#
# The shared look — palette, mascot, `cc_banner` — lives in cc-lib.sh; this file
# only adds the `/context` output and the slash-command interception below.
#
# `/context` is a slash command, not a bash builtin — so we intercept it via a
# DEBUG trap (see bottom). Category colors reuse the deck's accent palette so the
# recording matches the legend used elsewhere on the slide/talk.

source ./cc-lib.sh

cc_context() {
  printf "  ${BOLD}└ Context Usage${RST}\n"
  sleep 0.3

  # row 1 — the used 3%: a handful of colored cells, rest empty
  printf "    ${PINK}◼${RST} ${BLUE}◼${RST} ${PURPLE}◼${RST} ${ORANGE}◼${RST} ${YELLOW}◼${RST} ${YELLOW}◼${RST} ${SOFT}◼${RST} ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${BOLD}Opus 4.8 (1M context)${RST}\n"
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${DIM}claude-opus-4-8[1m]${RST}\n"
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${DIM}25.5k/1m tokens (3%%)${RST}\n"
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}\n"
  sleep 0.4
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${DIM}${ITAL}Estimated usage by category${RST}\n"
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${PINK}◼${RST} System prompt: ${BOLD}2.2k${RST} ${DIM}tokens (0.2%%)${RST}\n"
  sleep 0.25
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${BLUE}◼${RST} System tools: ${BOLD}4.6k${RST} ${DIM}tokens (0.5%%)${RST}\n"
  sleep 0.25
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${PURPLE}◼${RST} Custom agents: ${BOLD}5.1k${RST} ${DIM}tokens (0.5%%)${RST}\n"
  sleep 0.25
  printf "    ${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}${E}    ${ORANGE}◼${RST} Memory files: ${BOLD}2.8k${RST} ${DIM}tokens (0.3%%)${RST}\n"
  sleep 0.25
  printf "                                              ${YELLOW}◼${RST} Skills: ${BOLD}10.9k${RST} ${DIM}tokens (1.1%%)${RST}\n"
  sleep 0.25
  printf "                                              ${SOFT}◼${RST} Messages: ${BOLD}8${RST} ${DIM}tokens (0.0%%)${RST}\n"
  sleep 0.25
  printf "                                              ${DIM}□ Free space: 974.5k (97.4%%)${RST}\n"
  printf "\n"
  sleep 0.5
}

# `/context` is a slash command — bash treats a leading-slash word as a path and
# executes it directly, so command_not_found_handle never fires. Intercept it
# with a DEBUG trap instead: extdebug makes a non-zero trap return skip the
# about-to-run command, so we print the block and swallow the `/context` exec.
shopt -s extdebug
_cc_debug_trap() {
  if [[ "$BASH_COMMAND" == "/context" ]]; then
    cc_context
    return 1
  fi
}
trap '_cc_debug_trap' DEBUG
