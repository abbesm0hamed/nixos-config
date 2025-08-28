#!/usr/bin/env bash

# Script to cycle through system info display modes
STATE_FILE="/tmp/waybar-system-info-mode"

# Get current mode (default to 0 if file doesn't exist)
if [ -f "$STATE_FILE" ]; then
    mode=$(cat "$STATE_FILE")
else
    mode=0
fi

# Cycle to next mode (0->1->2->0)
next_mode=$(( (mode + 1) % 3 ))
echo $next_mode > "$STATE_FILE"

# Force waybar to refresh the module
pkill -RTMIN+8 waybar 2>/dev/null || true
