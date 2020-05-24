#!/bin/bash

session=$(tmux display-message -p '#S')
window=$(tmux display-message -p '#W')
pane=$(tmux display-message -p '#P')

paneId="$session:$window.$pane"

paneWidth=$(tmux display -p -t $paneId '#{pane_width}')
paneHeight=$(tmux display -p -t $paneId '#{pane_height}')
paneSize="(${paneWidth}, ${paneHeight})"

windowHeight=$(tmux display -p '#{window_height}')
windowWidth=$(tmux display -p '#{window_width}')
windowSize="(${windowWidth}, ${windowHeight})"

paneWPercent=$(( 100 * $paneWidth / $windowWidth))
paneHPercent=$(( 100 * $paneHeight / $windowHeight))
paneSizePercent="(${paneWPercent}%, ${paneHPercent}%)"

echo "$paneId (w, h): $paneSize / $windowSize ~= $paneSizePercent"

if [ $# -eq 1 ] && [ "$1" = "-f" ]
then
    tmux list-panes
fi
