# claude-p-json.tape — "recording as code" source for the `JSON is the contract` slide.
# Render:  cd starter/recordings && vhs claude-p-json.tape   (writes ../public/claude-p-json.webm)
# Output is checked-in media; THIS file is the source of truth — edit & re-render.
#
# Story: capture the print-mode JSON envelope ONCE, then explore it with real jq.
#   Beat 1 — `jq 'keys'`                       → it's an ENVELOPE (result + structured_output + metadata)
#   Beat 2 — `jq '.result'`                    → the answer as a STRING — opaque, you'd re-parse it
#   Beat 3 — `jq '.structured_output | keys'`  → --json-schema parsed that same answer into your 6 fields
#   Beat 4 — `jq '.structured_output | {...}'` → branch on it (verdict + metrics + the bugs)

Output ../public/claude-p-json.webm

Require bash

Set Shell "bash"
Set FontSize 22
Set Width 1280
Set Height 680
Set Padding 28
Set Margin 0
Set Theme "Catppuccin Mocha"
Set TypingSpeed 32ms

# --- setup (not recorded): minimal prompt + load the re-enactment shim ---
Hide
Type "PS1='\033[2m~/workout-tracker\033[0m $ '" Enter
Type "source ./claude-p-json-sim.sh" Enter
Type "clear" Enter
Show

# --- capture the print-mode envelope once (works silently, then returns) ---
# --bare keeps the run deterministic for CI; the schema is a real file, cat'd in.
Sleep 600ms
Type `OUT=$(claude --bare -p "$ACS" --allowedTools "Bash(agent-browser*)" \`
Sleep 150ms
Enter
Type `       --output-format json --json-schema "$(cat qa-report-schema.json)")`
Sleep 300ms
Enter
Sleep 3s

# --- Beat 1: json mode hands you an ENVELOPE, not prose ---
Type `echo "$OUT" | jq 'keys'`
Sleep 300ms
Enter
Sleep 2500ms

# --- Beat 2: .result is the answer as a STRING — opaque, you'd re-parse it ---
Type `echo "$OUT" | jq '.result'`
Sleep 300ms
Enter
Sleep 2800ms

# --- Beat 3: --json-schema parsed that same answer into the contract's shape ---
Type `echo "$OUT" | jq '.structured_output | keys'`
Sleep 300ms
Enter
Sleep 2500ms

# --- Beat 4: branch on it — verdict, metrics, the bugs ---
Type `echo "$OUT" | jq '.structured_output | {verdict, metrics, bugs: [.bugs[].title]}'`
Sleep 300ms
Enter
Sleep 3s

# hold the final frame — the shape a CI script reads every time
Sleep 2500ms
