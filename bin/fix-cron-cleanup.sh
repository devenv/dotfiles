#!/bin/bash
# Cleanup and fix remaining cron jobs

set -e

TARGET_HOST="nils-ec2"

echo "Cleaning up cron jobs on $TARGET_HOST..."

# 1. Update cron-team-pr-review.sh - note that a crafters-jobs job needs to be created
ssh "$TARGET_HOST" bash << 'SCRIPT'
cat > ~/.openclaw/shared-scripts/cron-team-pr-review.sh << 'EOF'
#!/usr/bin/env bash
# Team PR Review job for Crafters team
# NOTE: This job needs a corresponding openclaw cron job created (team-pr-review with crafters-jobs agent)
# For now, this wrapper just monitors status without triggering

export PATH="/usr/local/bin:/usr/bin:$PATH"
export GH_CONFIG_DIR=/home/nils/.config/gh

LOCK="/tmp/cron-team-pr-review.lock"
[ -f "$LOCK" ] && exit 0
trap 'rm -f "$LOCK"' EXIT
touch "$LOCK"

RESULT=$(bash /home/nils/.openclaw/shared-scripts/precheck-team-pr-review.sh /home/nils/.openclaw/workspace-crafters-jobs/.env 2>/dev/null)

if [ "$RESULT" = "SKIP" ]; then
  exit 0
fi

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $RESULT — monitoring (job not yet created in OpenClaw)"
# TODO: Once openclaw cron add supports crafters-jobs team-pr-review, uncomment:
# openclaw cron run <uuid> --timeout 5000
EOF
chmod +x ~/.openclaw/shared-scripts/cron-team-pr-review.sh
echo "✓ cron-team-pr-review.sh (awaiting cron job creation)"
SCRIPT

# 2. Delete cron-feedback-processor.sh entirely
ssh "$TARGET_HOST" bash << 'SCRIPT'
rm -f ~/.openclaw/shared-scripts/cron-feedback-processor.sh
echo "✓ Deleted cron-feedback-processor.sh"
SCRIPT

# 3. Fix cron-oq-resolver.sh - check if it's KG related
ssh "$TARGET_HOST" bash << 'SCRIPT'
echo "=== Checking cron-oq-resolver.sh ==="
cat ~/.openclaw/shared-scripts/cron-oq-resolver.sh | head -40

echo ""
echo "=== Checking precheck-oq-resolver.sh ==="
cat ~/.openclaw/shared-scripts/precheck-oq-resolver.sh | head -50
SCRIPT

echo ""
echo "Cleanup complete:"
echo "  ✓ cron-team-pr-review.sh - updated (awaiting crafters-jobs cron job)"
echo "  ✓ cron-feedback-processor.sh - deleted"
echo "  ℹ cron-oq-resolver.sh - reviewed below"
