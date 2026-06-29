# subtree.tape — "recording as code" for the payoff of the `git subtree add` slide:
# once VueUse lives in repos/, the agent READS it and writes like it.
# Render:  cd starter/recordings && vhs subtree.tape   (writes ../public/subtree.webm)
# Output is checked-in media; THIS file is the source of truth — edit & re-render.

Output ../public/subtree.webm

Require bash

Set Shell "bash"
Set FontSize 22
Set Width 1280
Set Height 980
Set Padding 28
Set Margin 0
Set Theme "Catppuccin Mocha"
Set TypingSpeed 32ms

# --- setup (not recorded): minimal prompt + load the re-enactment shim ---
Hide
Type "PS1='\033[2m~/workout-tracker\033[0m $ '" Enter
Type "source ./subtree-sim.sh" Enter
Type "clear" Enter
Show

Sleep 500ms
Type "claude" Enter
Sleep 800ms

# the genuine feature request, typed live into the REPL read
Type "Add a useRestTimer composable: count down between sets, auto-pause when the tab is hidden. Mirror the patterns in repos/vueuse — don't guess the API."
Sleep 700ms
Enter

# the shim streams the read-then-mirror run
Sleep 9s

# hold the final frame
Sleep 2500ms
