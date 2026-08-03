#!/bin/bash
# Create a new floating session with a number, or move pane to existing floating session if in one

TMUX_BIN=/opt/homebrew/bin/tmux
CURRENT_SESSION=$($TMUX_BIN display-message -p "#{session_name}" 2>/dev/null)

# If we're already in a floating session, move pane back to session 0
if [[ "$CURRENT_SESSION" =~ ^floating ]]; then
    $TMUX_BIN new-session -d -s 0 2>/dev/null
    NEXT_INDEX=$($TMUX_BIN list-windows -t 0 -F "#{window_index}" 2>/dev/null | tail -1 | awk "{print \$1+1}")
    if [ -z "$NEXT_INDEX" ]; then
        NEXT_INDEX=1
    fi
    $TMUX_BIN break-pane -d -t "0:$NEXT_INDEX" 2>/dev/null && $TMUX_BIN switch-client -t 0 2>/dev/null
    exit 0
fi

# Find the next available floating session number (check floating first, then floating1, floating2, etc.)
if ! $TMUX_BIN has-session -t "floating" 2>/dev/null; then
    FLOATING_SESSION="floating"
else
    NEXT_NUM=1
    while $TMUX_BIN has-session -t "floating$NEXT_NUM" 2>/dev/null; do
        NEXT_NUM=$((NEXT_NUM + 1))
    done
    FLOATING_SESSION="floating$NEXT_NUM"
fi

$TMUX_BIN new-session -d -s "$FLOATING_SESSION" 2>/dev/null
$TMUX_BIN set-option -t "$FLOATING_SESSION" status off 2>/dev/null

# Move current pane to the new floating session
$TMUX_BIN break-pane -d -t "$FLOATING_SESSION" 2>/dev/null
