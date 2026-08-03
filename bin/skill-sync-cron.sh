#!/bin/bash
# Wrapper for skill-sync.py to use from cron (which doesn't source ~/.zshrc).
#
# Operator setup (one-time):
#   1. Create ~/.config/skill-sync/env with:
#        ANTHROPIC_API_KEY="sk-ant-..."
#   2. chmod 600 ~/.config/skill-sync/env
#   3. Install cron entry: 0 5 * * * /Users/devenv/bin/skill-sync-cron.sh

set -uo pipefail

ENV_FILE="$HOME/.config/skill-sync/env"
LOG_FILE="$HOME/.local/share/skill-sync/sync.log"

mkdir -p "$(dirname "$LOG_FILE")"

if [ ! -r "$ENV_FILE" ]; then
    echo "$(date -u +%FT%TZ) ERR: $ENV_FILE missing or unreadable. See header for setup." >> "$LOG_FILE"
    exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "$(date -u +%FT%TZ) ERR: ANTHROPIC_API_KEY not set after sourcing $ENV_FILE" >> "$LOG_FILE"
    exit 1
fi

export ANTHROPIC_API_KEY
echo "$(date -u +%FT%TZ) skill-sync starting" >> "$LOG_FILE"
/Users/devenv/bin/skill-sync.py >> "$LOG_FILE" 2>&1
RC=$?
echo "$(date -u +%FT%TZ) skill-sync done rc=$RC" >> "$LOG_FILE"
exit $RC
