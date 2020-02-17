#!/usr/bin/env bash

screen -T xterm-256color -Sdm neuro
screen -S neuro -p 0 -X stuff "cat /opt/neuro/web-shell/readme^M"

MAX_RUN_TIME="${MAX_RUN_TIME:-"1d"}"
exec timeout "$MAX_RUN_TIME" "$@"
