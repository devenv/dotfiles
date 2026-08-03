#!/bin/bash
# Weekly sweep of regenerable caches. Never touches Docker volumes or user data.
set -uo pipefail

LOG=~/Library/Logs/disk-cleanup.log
exec >> "$LOG" 2>&1
echo "=== $(/bin/date) ==="

echo "-- npm cache --"
npm cache clean --force 2>&1

echo "-- brew cleanup --"
/opt/homebrew/bin/brew cleanup -s 2>&1

echo "-- uv cache --"
uv cache clean 2>&1

echo "-- pre-commit cache --"
rm -rf ~/.cache/pre-commit

echo "-- stray Docker Desktop installer DMGs --"
hdiutil info 2>/dev/null | grep -B2 "com.docker.install/DockerDesktop" | grep "/dev/disk" | awk '{print $1}' | while read -r dev; do
  echo "detaching $dev"
  hdiutil detach "$dev" -force 2>&1
done
find /var/folders -maxdepth 4 -path "*/T/DockerDesktopUpdates/*.dmg" -delete 2>/dev/null

echo "-- Docker image/build cache prune (volumes untouched) --"
if docker system df >/dev/null 2>&1; then
  docker image prune -af 2>&1
  docker builder prune -f 2>&1
else
  echo "Docker daemon not running, skipped"
fi

echo "-- disk free after cleanup --"
df -h /System/Volumes/Data

echo
