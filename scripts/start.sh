#!/bin/bash

# Use ./start.sh config (ex: ./start.sh weather_simple)
CONKY_DIR="$HOME/.config/conky/Essentials"
CONFIG_NAME="${1:-no_weather}"
CONFIG_FILE="$CONKY_DIR/$CONFIG_NAME.conf"

# Check directory and requested config
cd $CONKY_DIR || exit 1
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: '$CONFIG_FILE' doesn't exist" >&2
    exit 1
fi

# Kill current instances of Conky first (comment this if you are using multiple widgets)
./scripts/stop.sh

# Start widget
conky --config="$CONFIG_FILE"

cd -

exit 0
