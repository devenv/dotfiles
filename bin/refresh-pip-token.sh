#!/bin/bash
# Refresh CodeArtifact pip token on Lightsail
# Runs from local machine (has org profile)
# Cron: 0 */11 * * *

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export HOME="${HOME:-/Users/devenv}"

LOG="/tmp/pip-token-refresh.log"

TOKEN=$(aws codeartifact get-authorization-token --domain nilus --domain-owner 011574297736 --region us-east-1 --profile org --query authorizationToken --output text 2>>"$LOG")
if [ -z "$TOKEN" ]; then
  echo "$(date): Failed to get CodeArtifact token" >> "$LOG"
  exit 1
fi

# Update local pip config
aws codeartifact login --tool pip --domain nilus --domain-owner 011574297736 \
  --repository nilus-pypi --region us-east-1 --profile org >>"$LOG" 2>&1

# Copy to Lightsail server
PIP_CONF="[global]
timeout = 60
index-url = https://aws:${TOKEN}@nilus-011574297736.d.codeartifact.us-east-1.amazonaws.com/pypi/nilus-pypi/simple/
no-cache-dir = true"

ssh -o ConnectTimeout=10 lightsail-oc "mkdir -p ~/.config/pip && cat > ~/.config/pip/pip.conf << 'PIPEOF'
${PIP_CONF}
PIPEOF" 2>>"$LOG"

echo "$(date): Token refreshed and copied (${#TOKEN} chars)" >> "$LOG"
