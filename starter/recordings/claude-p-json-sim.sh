# claude-p-json-sim.sh — faithful RE-ENACTMENT of `claude -p --output-format json
# --json-schema`, the structured-output path that makes print mode pipeline-safe.
#
# Verified against the real CLI (claude 2.1.195): with `--output-format json`,
# `-p` does NOT print the assistant text — it prints ONE JSON object, a metadata
# ENVELOPE. The model's answer is `.result` (a STRING). When you also pass
# `--json-schema`, the same answer is parsed into `.structured_output` — a real
# object in exactly your schema's shape.
#
# The structured_output below mirrors the REAL workout-tracker QA schema
# (.github/schemas/qa-report-schema.json): verdict + summary + tests[] + bugs[] +
# console_errors[] + metrics, with the real enums (verdict HEALTHY|MINOR_ISSUES|
# CRITICAL_BUGS, severity critical|major|minor|suggestion) and the real bug fields
# (id, severity, title, description, steps_to_reproduce, expected, actual).
#
# The tape captures this envelope ONCE into $OUT, then explores it with real `jq`
# — so every key list and projection on screen is genuine jq over a real-shaped
# object. Content is the ticket-#142 run, compressed (tests[] trimmed to samples;
# metrics report the full counts). The brief sleep stands in for the silent
# browser work `-p` does before it emits.
#
# Sourced by claude-p-json.tape, which types the genuine command. Defining a
# shell function named `claude` shadows the real binary for the recording only.

source ./cc-lib.sh

# The acceptance criteria the typed command references as $ACS. The contract
# itself is a REAL JSON Schema checked in next to this file (qa-report-schema.json)
# — the tape cats it into --json-schema, exactly as a CI job would. (The CLI
# rejects anything that isn't valid JSON Schema, so the on-screen command is
# genuinely runnable, not jq-projection shorthand.)
ACS='Verify the ACs, then explore'

claude() {
  # `-p` runs silently while the agent drives the browser; this pause stands in
  # for that work. Then print mode emits exactly one thing: the JSON envelope.
  sleep 2.2

  cat <<'JSON'
{
  "type": "result",
  "subtype": "success",
  "is_error": false,
  "num_turns": 70,
  "duration_ms": 631240,
  "total_cost_usd": 1.84,
  "result": "{\"verdict\":\"MINOR_ISSUES\",\"summary\":\"7/7 ACs pass; 2 minor issues\",\"bugs\":[...]}",
  "structured_output": {
    "verdict": "MINOR_ISSUES",
    "summary": "7/7 acceptance criteria pass against the live preview; 2 minor issues found beyond the ticket.",
    "tests": [
      { "name": "Create workout from template", "area": "core_features", "result": "pass", "details": "Logged 3 sets; persisted across reload" },
      { "name": "Rest-timer announced to AT", "area": "accessibility", "result": "fail", "details": "Countdown has no role=timer" }
    ],
    "bugs": [
      {
        "id": 1,
        "severity": "minor",
        "title": "Template detail miscounts blocks",
        "description": "Subtitle shows the wrong block count",
        "steps_to_reproduce": ["Open a template with one block", "Read the subtitle"],
        "expected": "reads \"with 1 block\"",
        "actual": "reads \"with 0 blocks\""
      },
      {
        "id": 2,
        "severity": "minor",
        "title": "Rest-timer not announced to screen readers",
        "description": "Countdown is not exposed to assistive tech",
        "steps_to_reproduce": ["Start a workout", "Reach the rest timer"],
        "expected": "exposes role=\"timer\"",
        "actual": "no role; screen readers stay silent"
      }
    ],
    "console_errors": [],
    "metrics": { "total_tests": 9, "passed": 7, "failed": 2, "critical_bugs": 0, "major_bugs": 0, "minor_bugs": 2 }
  }
}
JSON
}
