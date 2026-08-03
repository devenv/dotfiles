#!/bin/bash
# List background session

TMUX_BIN=/opt/homebrew/bin/tmux
if $TMUX_BIN has-session -t background 2>/dev/null; then
    BACKGROUND_INFO=$($TMUX_BIN list-sessions -F "#{session_name} (#{session_windows} windows)" 2>/dev/null | grep "^background")
    echo "Background session:"
    echo "$BACKGROUND_INFO"
else
    echo "No background session exists"
fi
