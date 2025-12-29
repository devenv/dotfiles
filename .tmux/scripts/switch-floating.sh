#!/bin/bash
# Switch to background session (like parking)

TMUX_BIN=/opt/homebrew/bin/tmux
CURRENT_SESSION=$($TMUX_BIN display-message -p "#{session_name}" 2>/dev/null)

# If we're in background session, switch back to session 0
if [ "$CURRENT_SESSION" = "background" ]; then
    $TMUX_BIN switch-client -t 0 2>/dev/null
    exit 0
fi

# Check if background session exists
if ! $TMUX_BIN has-session -t background 2>/dev/null; then
    # No background session exists, create one
    $TMUX_BIN new-session -d -s background 2>/dev/null
fi

# Switch to background session
$TMUX_BIN switch-client -t background 2>/dev/null
