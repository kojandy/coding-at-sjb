#!/bin/bash
if [ "$(playerctl status 2> /dev/null)" = "Playing" ]; then
    echo "▶️ "$(playerctl metadata title 2> /dev/null)
else
    echo ""
fi
