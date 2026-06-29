# context.tape — "recording as code" source for the `/context: see your budget` slide.
# Render:  cd starter/recordings && vhs context.tape   (writes ../public/context.webm)
# Output is checked-in media; THIS file is the source of truth — edit & re-render.

Output ../public/context.webm

Require bash

Set Shell "bash"
Set FontSize 20
Set Width 1500
Set Height 720
Set Padding 16
Set Margin 0
Set Theme "Catppuccin Mocha"
Set TypingSpeed 60ms

# --- setup (not recorded): Claude-Code-style prompt, load shim, paint banner ---
Hide
Type "PS1=$'\033[38;2;255;107;237m❯\033[0m '" Enter
Type "source ./context-sim.sh" Enter
Type "clear; cc_banner '~/Projects/slidev/dwx-claude-code-26' mcp" Enter
Show

# --- the genuine slash command, typed live ---
Sleep 700ms
Type "/context"
Sleep 400ms
Enter
Sleep 4s

Sleep 2s
