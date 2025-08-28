#!/bin/bash

# Combined system info script for waybar
# Shows CPU, Memory, and Storage in one module
# Cycles through different display modes

# State file to track current display mode
STATE_FILE="/tmp/waybar-system-info-mode"

# Get current mode (default to 0 if file doesn't exist)
if [ -f "$STATE_FILE" ]; then
    mode=$(cat "$STATE_FILE")
else
    mode=0
fi

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
cpu_usage=${cpu_usage%.*}  # Remove decimal part

# Get memory usage
memory_info=$(free | grep '^Mem')
memory_used=$(echo $memory_info | awk '{print $3}')
memory_total=$(echo $memory_info | awk '{print $2}')
memory_percentage=$(awk "BEGIN {printf \"%.0f\", ($memory_used/$memory_total)*100}")
memory_gb=$(echo $memory_info | awk '{printf "%.1fG", $3/1024/1024}')

# Get storage usage (root filesystem)
storage_info=$(df -h / | tail -1)
storage_used=$(echo $storage_info | awk '{print $5}' | sed 's/%//')
storage_avail=$(echo $storage_info | awk '{print $4}')

# Determine overall status class
class=""
if [ "$cpu_usage" -gt 80 ] || [ "$memory_percentage" -gt 85 ] || [ "$storage_used" -gt 90 ]; then
    class="critical"
elif [ "$cpu_usage" -gt 60 ] || [ "$memory_percentage" -gt 70 ] || [ "$storage_used" -gt 80 ]; then
    class="warning"
fi

# Create tooltip with detailed info
tooltip="CPU: ${cpu_usage}%\\nMemory: ${memory_percentage}% (${memory_gb})\\nStorage: ${storage_used}% (${storage_avail} free)\\n\\nClick to cycle through views"

# Display based on current mode
case $mode in
    0) # CPU mode
        text=" ${cpu_usage}%"
        ;;
    1) # Memory mode
        text=" ${memory_percentage}%"
        ;;
    2) # Storage mode
        text="󰋊 ${storage_used}%"
        ;;
    *) # Reset to CPU mode
        text=" ${cpu_usage}%"
        mode=0
        ;;
esac

# Output JSON
echo "{\"text\":\"${text}\", \"tooltip\":\"${tooltip}\", \"class\":\"${class}\"}"
