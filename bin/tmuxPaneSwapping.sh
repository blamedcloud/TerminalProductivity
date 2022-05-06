#!/bin/bash

pane_id_file="$HOME/.tmux_pane_id.txt"
[ ! -f $pane_id_file ] && touch $pane_id_file
pane_id=$(cat $pane_id_file)

#if a pane is recorded
if [ -n "$pane_id" ]
then
    # swap the recorded pane with the current one and remove the pane record
    new_pane_id=$(tmux display-message -p '#S:#I.#P')
    tmux swap-pane -s $new_pane_id -t $pane_id
    echo "" > $pane_id_file
else
    # record the current pane
    tmux display-message -p '#S:#I.#P' > $pane_id_file
fi
