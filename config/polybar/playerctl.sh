#!/bin/bash
player_status=$(LD_LIBRARY_PATH=/tmp/sjb/usr/lib playerctl status 2> /dev/null)
title=$(LD_LIBRARY_PATH=/tmp/sjb/usr/lib playerctl metadata title 2> /dev/null)
artist=$(LD_LIBRARY_PATH=/tmp/sjb/usr/lib playerctl metadata artist 2> /dev/null)

if [ ! "$artist" = "" ]; then
    title=$artist' - '$title
fi

if [ "$player_status" = "Playing" ]; then
    echo " ""$title"
elif [ "$player_status" = "Paused" ]; then
    echo " ""$title"
else
    echo ""
fi
