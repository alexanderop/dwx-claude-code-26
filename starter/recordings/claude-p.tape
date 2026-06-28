# claude-p.tape — "recording as code" source for the `First: claude -p` slide.
# Render:  cd starter/recordings && vhs claude-p.tape   (writes ../public/claude-p.webm)
# Output is checked-in media; THIS file is the source of truth — edit & re-render.

Output ../public/claude-p.webm

Require bash

Set Shell "bash"
Set FontSize 24
Set Width 1280
Set Height 600
Set Padding 28
Set Margin 0
Set Theme "Catppuccin Mocha"
Set TypingSpeed 55ms

# --- setup (not recorded): minimal prompt + load the re-enactment shim ---
Hide
Type "PS1='\033[2m~/workout-tracker\033[0m $ '" Enter
Type "source ./claude-p-sim.sh" Enter
Type "clear" Enter
Show

# --- the genuine command, typed live ---
Sleep 600ms
Type `claude -p "Test this preview like a QA engineer" \`
Sleep 200ms
Enter
Type `  --allowedTools "Bash(agent-browser*)"`
Sleep 700ms
Enter

# the shim streams the condensed-but-truthful print-mode output
Sleep 9s

# hold the final frame
Sleep 2500ms
