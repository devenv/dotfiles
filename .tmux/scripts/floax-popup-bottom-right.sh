#!/bin/bash
# Custom popup function for tmux-floax that positions in top right corner with margins

CURRENT_DIR="$HOME/.tmux/plugins/tmux-floax/scripts"
source "$CURRENT_DIR/utils.sh"

# Get session name (should be 'floating' from config)
FLOAX_SESSION_NAME=$(envvar_value FLOAX_SESSION_NAME)
if [ -z "$FLOAX_SESSION_NAME" ]; then
    FLOAX_SESSION_NAME="floating"
fi

# Ensure session exists and has windows
if ! tmux has-session -t "$FLOAX_SESSION_NAME" 2>/dev/null; then
    tmux new-session -d -s "$FLOAX_SESSION_NAME"
    tmux set-option -t "$FLOAX_SESSION_NAME" status off
fi

# Get dimensions - use configured or default to smaller size
FLOAX_WIDTH=$(envvar_value FLOAX_WIDTH)
FLOAX_HEIGHT=$(envvar_value FLOAX_HEIGHT)
FLOAX_WIDTH="${FLOAX_WIDTH:-40%}"
FLOAX_HEIGHT="${FLOAX_HEIGHT:-50%}"

FLOAX_TITLE=$(envvar_value FLOAX_TITLE)
if [ -z "$FLOAX_TITLE" ]; then
    FLOAX_TITLE="FloaX"
fi

FLOAX_BORDER_COLOR=$(envvar_value FLOAX_BORDER_COLOR)
FLOAX_BORDER_COLOR="${FLOAX_BORDER_COLOR:-magenta}"
FLOAX_TEXT_COLOR=$(envvar_value FLOAX_TEXT_COLOR)
FLOAX_TEXT_COLOR="${FLOAX_TEXT_COLOR:-blue}"

tmux set-option -t "$FLOAX_SESSION_NAME" detach-on-destroy on

# Check if session has any windows before showing popup
WINDOW_COUNT=$(tmux list-windows -t "$FLOAX_SESSION_NAME" 2>/dev/null | wc -l | tr -d ' ')
if [ "$WINDOW_COUNT" -eq 0 ]; then
    # No windows in session, exit silently
    exit 0
fi

# Position in top right corner with margins
# Calculate x position: right edge minus width minus margin
# For 40% width with 2% margin: x = 100% - 40% - 2% = 58% from left
# Calculate y position: top with margin
# For 2% margin from top: y = 2% from top
tmux popup \
    -S fg="$FLOAX_BORDER_COLOR" \
    -s fg="$FLOAX_TEXT_COLOR" \
    -T "$FLOAX_TITLE" \
    -w "$FLOAX_WIDTH" \
    -h "$FLOAX_HEIGHT" \
    -x "58%" \
    -y "2%" \
    -b rounded \
    -E \
    "tmux attach-session -t \"$FLOAX_SESSION_NAME\""
