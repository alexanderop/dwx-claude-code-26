# claude-p-sim.sh — faithful RE-ENACTMENT of a real `claude -p` print-mode run.
#
# Print mode (`claude -p`, default text output) prints NOTHING while it works —
# no banner, no `●` tool lines, no `⎿` connectors, no turn-by-turn progress.
# Those belong to the interactive REPL. `-p` runs silently, then prints ONE
# thing: the final assistant text. That is the whole point of this slide —
# "Claude Code without the chat UI" — so the clip must look like that, not like
# the interactive UI pasted onto a headless command.
#
# Verified against the real CLI (claude 2.1.195, agent-browser 0.27.1): a QA
# prompt with `--allowedTools "Bash(agent-browser*)"` opens the page, snapshots,
# and prints only the report. (To SEE the intermediate agent-browser calls you
# must opt into `--output-format stream-json --verbose`, which emits raw JSON —
# that's a different slide.)
#
# Content below is the real workout-tracker QA run from the deck, compressed:
# real verdict (7/7 ACs), real two bugs. Format now matches real text mode.
#
# Sourced by claude-p.tape, which types the genuine command. Defining a shell
# function named `claude` shadows the real binary for the recording only.

source ./cc-lib.sh

claude() {
  # `-p` works silently while the agent drives the browser — the recording's
  # pause (in the .tape) stands in for that. Then it prints the final report.
  printf "\n"
  sleep 0.6

  printf "${BOLD}QA report — workout-tracker preview${RST}\n\n"
  sleep 0.5

  printf "Acceptance criteria: ${GREEN}7/7 verified against the live app.${RST}\n\n"
  sleep 0.8

  printf "Two issues beyond the ticket (neither in the ACs):\n\n"
  sleep 0.4
  printf "  • copy:  template detail reads \"with 0 blocks\" when it has one\n"
  sleep 0.4
  printf "  • a11y:  rest-timer countdown has no role=\"timer\", so screen\n"
  printf "           readers never announce it\n\n"
  sleep 0.9

  printf "Wrote ${BOLD}qa-report.md${RST} and machine-readable ${BOLD}verdict.json${RST}.\n\n"
  sleep 0.6
}
