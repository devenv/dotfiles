#!/bin/bash
# Fix critical cron jobs to work with current setup

set -e

TARGET_HOST="nils-ec2"

echo "Updating critical jobs on $TARGET_HOST..."

# 1. Fix worktree-cleanup.sh - look for actual worktree lock patterns
ssh "$TARGET_HOST" bash << 'SCRIPT'
cat > ~/.openclaw/scripts/worktree-cleanup.sh << 'EOF'
#!/bin/bash
# Clean up stale worktrees and lock files (>4 hours old)

# 1. Remove stale git worktree lock files (lock after checkout)
find /home/nils/nilus/core-* -maxdepth 1 -name '.git' -type d 2>/dev/null | while read gitdir; do
    lockfile="${gitdir%/.git}/.git/index.lock"
    if [ -f "$lockfile" ]; then
        AGE=$(( $(date +%s) - $(stat -c %Y "$lockfile") ))
        if [ $AGE -gt 14400 ]; then
            echo "Removing stale git lock: $lockfile (age: $((AGE/3600))h)"
            rm -f "$lockfile"
        fi
    fi
done

# 2. Remove stale worktree directories (unused for >24 hours)
find /home/nils/nilus/core-* -maxdepth 0 -type d 2>/dev/null | while read wt; do
    AGE=$(( $(date +%s) - $(stat -c %Y "$wt") ))
    if [ $AGE -gt 86400 ]; then
        name=$(basename "$wt")
        # Only remove non-critical worktrees (skip core, core-work)
        if [[ "$name" != "core" && "$name" != "core-work" ]]; then
            echo "Removing stale worktree: $wt (age: $((AGE/3600))h, unused)"
            rm -rf "$wt" 2>/dev/null || echo "  (failed, may be in use)"
        fi
    fi
done

# 3. List active worktrees for monitoring
cd /home/nils/nilus/core-work 2>/dev/null && {
    echo "Active worktrees:"
    git worktree list 2>/dev/null || echo "  (failed)"
}
EOF
chmod +x ~/.openclaw/scripts/worktree-cleanup.sh
echo "✓ Updated worktree-cleanup.sh"
SCRIPT

# 2. Fix health-trim.sh - remove embedded token issue workaround
ssh "$TARGET_HOST" bash << 'SCRIPT'
cat > ~/.openclaw/scripts/health-trim.sh << 'EOF'
#!/bin/bash
# OpenClaw Health Check & Session Trim
# Trims sessions.json files > 5MB, keeps newest 30 entries
# Logs to /home/nils/.openclaw/logs/health-trim.log

LOG=/home/nils/.openclaw/logs/health-trim.log
mkdir -p /home/nils/.openclaw/logs

echo "=== $(date -Iseconds) ===" >> $LOG

# 1. Check gateway RAM
GW_PID=$(pgrep -f openclaw-gateway | head -1)
if [ -z "$GW_PID" ]; then
    echo "ALERT: Gateway not running!" >> $LOG
    exit 1
fi

GW_RSS=$(ps -o rss= -p $GW_PID 2>/dev/null | tr -d ' ')
GW_MB=$((GW_RSS / 1024))
echo "Gateway PID=$GW_PID RSS=${GW_MB}MB" >> $LOG

if [ $GW_MB -gt 3000 ]; then
    echo "ALERT: Gateway using ${GW_MB}MB (>3GB), restarting..." >> $LOG
    # Use systemctl instead of kill + nohup for cleaner restart
    systemctl --user restart openclaw-gateway.service 2>&1 >> $LOG || {
        kill $GW_PID
        sleep 3
        # Fallback: use openclaw command
        openclaw gateway restart >> $LOG 2>&1 || true
    }
    echo "Gateway restarted" >> $LOG
fi

# 2. Trim bloated sessions.json
python3 -c "
import json, os, sys

base = '/home/nils/.openclaw/agents'
trimmed = []
for agent in os.listdir(base):
    sf = os.path.join(base, agent, 'sessions', 'sessions.json')
    if not os.path.isfile(sf):
        continue
    size = os.path.getsize(sf)
    if size < 5_000_000:  # only trim > 5MB
        continue
    try:
        with open(sf) as f:
            data = json.load(f)
    except:
        continue
    if not isinstance(data, dict) or len(data) <= 30:
        continue
    before = len(data)
    items = sorted(data.items(), key=lambda x: x[1].get('lastActivity', x[1].get('updatedAt', '')), reverse=True)
    kept = dict(items[:30])
    bak = sf + '.bak'
    if os.path.exists(bak):
        os.remove(bak)
    os.rename(sf, bak)
    with open(sf, 'w') as f:
        json.dump(kept, f)
    trimmed.append(f'{agent}: {size//1024//1024}MB/{before} -> {len(kept)} entries')

if trimmed:
    print('TRIMMED: ' + '; '.join(trimmed))
else:
    print('No trimming needed')
" >> $LOG 2>&1

# 3. Clean stale locks (>30 min old)
find /home/nils/.openclaw/agents -name '*.lock' -mmin +30 -delete -print 2>/dev/null | while read f; do
    echo "Cleaned stale lock: $f" >> $LOG
done

# 4. Disk check
DISK_PCT=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
if [ $DISK_PCT -gt 85 ]; then
    echo "ALERT: Disk at ${DISK_PCT}%" >> $LOG
fi

# 5. Memory check
FREE_MB=$(free -m | awk '/Mem:/{print $7}')
echo "Available RAM: ${FREE_MB}MB, Disk: ${DISK_PCT}%" >> $LOG
echo "---" >> $LOG
EOF
chmod +x ~/.openclaw/scripts/health-trim.sh
echo "✓ Updated health-trim.sh"
SCRIPT

echo ""
echo "Critical job scripts updated. Ready to enable."
