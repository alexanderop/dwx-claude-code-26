# goal.tape — "recording as code" for the "A goal gives the loop a finish line" slide.
# Render:  cd starter/recordings && vhs goal.tape   (writes ../public/goal.webm)

Output ../public/goal.webm

Require bash

Set Shell "bash"
Set FontSize 23
Set Width 1280
Set Height 620
Set Padding 28
Set Margin 0
Set Theme "Catppuccin Mocha"
Set TypingSpeed 38ms

Hide
Type "PS1='\033[2m~/workout-tracker\033[0m $ '" Enter
Type "source ./goal-sim.sh" Enter
Type "clear" Enter
Show

Sleep 500ms
Type "claude" Enter
Sleep 800ms

# slash command typed live at the Claude prompt (single line → one read)
Type "/goal raise total test coverage by at least 5 points, run pnpm test:coverage, only change test files"
Sleep 700ms
Enter

# the shim streams the self-checking iterations
Sleep 9s

Sleep 2500ms
