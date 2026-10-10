#!/usr/bin/env bash
# main session: zene (sctui + deezer-tui)
s=main

tmux new-session -d -s "$s" -n soundcloud
tmux send-keys   -t "=$s:soundcloud" 'until [ -n "$(tmux list-clients -t =main)" ]; do sleep 0.3; done; clear; sctui' Enter

tmux new-window  -t "=$s" -n deezer
tmux send-keys   -t "=$s:deezer" 'deezer-tui' Enter

tmux select-window -t "=$s:soundcloud"
