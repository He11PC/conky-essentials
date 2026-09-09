#!/bin/bash

if pidof conky >/dev/null; then
    killall conky

    count=0
    # Wait limit = 3 seconds (15*0.2)
    while pidof conky >/dev/null && [ $count -lt 15 ]; do
        sleep 0.2
        ((count++))
    done

    if pidof conky >/dev/null; then
        killall -9 conky
        sleep 0.5
    fi
fi

exit 0
