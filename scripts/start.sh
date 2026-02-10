#!/bin/bash

# Use ./start.sh config (ex: ./start.sh weather_simple)

killall conky
cd /home/$(whoami)/.config/conky/Essentials
config="${1:-no_weather}"
conky --daemonize --pause=5 --config="$config.conf"
cd -
exit 0
