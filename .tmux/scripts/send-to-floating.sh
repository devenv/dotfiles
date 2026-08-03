#!/bin/bash
# Send current pane to background session (like parking, but for panes)

TMUX_BIN=/opt/homebrew/bin/tmux
CURRENT_SESSION=$($TMUX_BIN display-message -p "#{session_name}" 2>/dev/null)

# If we're in background session, move pane back to session 0
if [ "$CURRENT_SESSION" = "background" ]; then
    $TMUX_BIN new-session -d -s 0 2>/dev/null
    NEXT_INDEX=$($TMUX_BIN list-windows -t 0 -F "#{window_index}" 2>/dev/null | tail -1 | awk "{print \$1+1}")
    if [ -z "$NEXT_INDEX" ] || [ "$NEXT_INDEX" = "" ]; then
        NEXT_INDEX=1
    fi
    $TMUX_BIN break-pane -d -t "0:$NEXT_INDEX" 2>/dev/null
    $TMUX_BIN switch-client -t 0 2>/dev/null
    exit 0
fi

# Create background session if it doesn't exist
$TMUX_BIN new-session -d -s background 2>/dev/null
$TMUX_BIN set-option -t background status off 2>/dev/null

# Break pane into the background session (will create a window if none exists)
$TMUX_BIN break-pane -d -t background 2>/dev/null
