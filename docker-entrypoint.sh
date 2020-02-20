#!/usr/bin/env bash

echo "defscrollback 10000" >> ~/.screenrc
echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc
screen -T xterm-256color -Sdm neuro
screen -S neuro -p 0 -X stuff "cd ~; cat /opt/neuro/web-shell/readme^M"

MAX_RUN_TIME="${MAX_RUN_TIME:-"1d"}"
exec timeout "$MAX_RUN_TIME" "$@"
