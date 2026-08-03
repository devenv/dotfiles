#!/bin/bash
# Daily free-space check. Notifies if the data volume drops below threshold.
set -uo pipefail

THRESHOLD_GB=15
LOG=~/Library/Logs/disk-space-watch.log
exec >> "$LOG" 2>&1
echo "=== $(/bin/date) ==="

avail_line=$(df -g /System/Volumes/Data | tail -1)
avail_gb=$(echo "$avail_line" | awk '{print $4}')

echo "Available: ${avail_gb}Gi (threshold ${THRESHOLD_GB}Gi)"

if [ "$avail_gb" -lt "$THRESHOLD_GB" ]; then
  /usr/bin/osascript -e "display notification \"Only ${avail_gb}GB free on disk — run disk cleanup.\" with title \"Low Disk Space\" sound name \"Basso\""
  echo "Notified: low disk space"
fi
