#!/usr/bin/env bash

echo "defscrollback 10000" >> ~/.screenrc
echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc
screen -T xterm-256color -Sdm apolo
screen -S apolo -p 0 -X stuff "cd $WORKDIR; cat /opt/apolo/web-shell/apolo.readme^M"

exec "$@"
