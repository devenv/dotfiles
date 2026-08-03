#!/bin/bash
# Fix PR/CR cron jobs to work with current setup
# Only enable jobs that actually exist

set -e

TARGET_HOST="nils-ec2"

echo "Fixing PR/CR jobs on $TARGET_HOST..."

# 1. Fix cron-pr-pipeline.sh - this one works (job exists)
ssh "$TARGET_HOST" bash << 'SCRIPT'
cat > ~/.openclaw/shared-scripts/cron-pr-pipeline.sh << 'EOF'
#!/usr/bin/env bash
# System crontab wrapper for pr-pipeline
# Checks for open PRs, triggers job only if needed
set -euo pipefail

export PATH="/usr/local/bin:/usr/bin:$PATH"
export GH_CONFIG_DIR=/home/nils/.config/gh

LOCK="/tmp/cron-pr-pipeline.lock"
[ -f "$LOCK" ] && exit 0
trap 'rm -f "$LOCK"' EXIT
touch "$LOCK"

RESULT=$(bash /home/nils/.openclaw/shared-scripts/precheck-pr-pipeline.sh /home/nils/.openclaw/workspace-boris-jobs/.env 2>/dev/null)

if [ "$RESULT" = "SKIP" ]; then
  exit 0
fi

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $RESULT — triggering pr-pipeline"
openclaw cron run e6f0375b-2659-4a9b-9a9c-36860ae4b459 --timeout 5000 2>/dev/null || true
EOF
chmod +x ~/.openclaw/shared-scripts/cron-pr-pipeline.sh
echo "✓ cron-pr-pipeline.sh (job exists)"
SCRIPT

# 2. Fix cron-team-pr-review.sh - job doesn't exist, disable it
ssh "$TARGET_HOST" bash << 'SCRIPT'
cat > ~/.openclaw/shared-scripts/cron-team-pr-review.sh << 'EOF'
#!/usr/bin/env bash
# Team PR Review job
# NOTE: Original cron job (uuid 70791892...) was for version-bump, not team review
# Team PR review functionality moved to lower-decks-pr-review cron job
# This script is DISABLED until team review job is created

# For now, just check status without triggering
export PATH="/usr/local/bin:/usr/bin:$PATH"
export GH_CONFIG_DIR=/home/nils/.config/gh

LOCK="/tmp/cron-team-pr-review.lock"
[ -f "$LOCK" ] && exit 0
trap 'rm -f "$LOCK"' EXIT
touch "$LOCK"

RESULT=$(bash /home/nils/.openclaw/shared-scripts/precheck-team-pr-review.sh /home/nils/.openclaw/workspace-boris-jobs/.env 2>/dev/null)

if [ "$RESULT" != "SKIP" ]; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $RESULT — would trigger team-pr-review (DISABLED: job not found)"
fi

# Disabled: openclaw cron run <uuid> --timeout 5000
EOF
chmod +x ~/.openclaw/shared-scripts/cron-team-pr-review.sh
echo "✓ cron-team-pr-review.sh (DISABLED - job doesn't exist)"
SCRIPT

# 3. Fix cron-feedback-processor.sh - job doesn't exist, disable it
ssh "$TARGET_HOST" bash << 'SCRIPT'
cat > ~/.openclaw/shared-scripts/cron-feedback-processor.sh << 'EOF'
#!/usr/bin/env bash
# Feedback processor job
# NOTE: Original cron job (uuid 09da9e14...) no longer exists
# Feedback processing is now handled by agent feedback loop
# This script is DISABLED

set -euo pipefail
export PATH="/usr/local/bin:/usr/bin:$PATH"

LOCK="/tmp/cron-feedback-processor.lock"
[ -f "$LOCK" ] && exit 0
trap 'rm -f "$LOCK"' EXIT
touch "$LOCK"

RESULT=$(bash /home/nils/.openclaw/shared-scripts/precheck-feedback-inbox.sh 2>/dev/null || echo "SKIP")

if [ "$RESULT" != "SKIP" ]; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $RESULT — would trigger feedback-processor (DISABLED: job not found)"
fi

# Disabled: openclaw cron run 09da9e14-55ba-4d12-9880-5192ac3d0623 --timeout 5000
EOF
chmod +x ~/.openclaw/shared-scripts/cron-feedback-processor.sh
echo "✓ cron-feedback-processor.sh (DISABLED - job doesn't exist)"
SCRIPT

# 4. Fix cron-oq-resolver.sh - job doesn't exist, disable it
ssh "$TARGET_HOST" bash << 'SCRIPT'
cat > ~/.openclaw/shared-scripts/cron-oq-resolver.sh << 'EOF'
#!/usr/bin/env bash
# Open Questions resolver job
# NOTE: Original cron job (uuid 3973944f...) no longer exists
# This script is DISABLED

set -euo pipefail
export PATH="/usr/local/bin:/usr/bin:$PATH"

LOCK="/tmp/cron-oq-resolver.lock"
[ -f "$LOCK" ] && exit 0
trap 'rm -f "$LOCK"' EXIT
touch "$LOCK"

RESULT=$(bash /home/nils/.openclaw/shared-scripts/precheck-oq-resolver.sh 2>/dev/null || echo "SKIP")

if [ "$RESULT" != "SKIP" ]; then
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $RESULT — would trigger oq-resolver (DISABLED: job not found)"
fi

# Disabled: openclaw cron run 3973944f-ec23-4bab-ad68-79a425108970 --timeout 5000
EOF
chmod +x ~/.openclaw/shared-scripts/cron-oq-resolver.sh
echo "✓ cron-oq-resolver.sh (DISABLED - job doesn't exist)"
SCRIPT

echo ""
echo "PR/CR job scripts fixed. Only pr-pipeline will actually trigger."
