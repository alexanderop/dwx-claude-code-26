# vp.tape — "recording as code" for the "Vite+ wraps both behind one CLI" slide.
# Render:  cd starter/recordings && vhs vp.tape   (writes ../public/vp-check.webm)

Output ../public/vp-check.webm

Require bash

Set Shell "bash"
Set FontSize 24
Set Width 1280
Set Height 600
Set Padding 28
Set Margin 0
Set Theme "Catppuccin Mocha"
Set TypingSpeed 55ms

Hide
Type "PS1='\033[2m~/workout-tracker\033[0m $ '" Enter
Type "source ./vp-sim.sh" Enter
Type "clear" Enter
Show

Sleep 500ms
Type "vp check"
Sleep 300ms
Enter
Sleep 4s

Type "vp test"
Sleep 300ms
Enter
Sleep 2500ms

Type "vp build"
Sleep 300ms
Enter
Sleep 3s

Sleep 2s
