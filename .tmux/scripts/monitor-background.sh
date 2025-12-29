#!/bin/bash
# Enable activity monitoring for background (detached) sessions

TMUX_BIN=/opt/homebrew/bin/tmux

# Get list of all sessions with their attachment status
ALL_SESSIONS=$($TMUX_BIN list-sessions -F "#{session_name}:#{session_attached}" 2>/dev/null)

# Get currently attached session (if any)
CURRENT_SESSION=$($TMUX_BIN display-message -p "#{session_name}" 2>/dev/null || echo "")

# Enable monitor-activity for all detached sessions
while IFS=: read -r SESSION_NAME IS_ATTACHED; do
    if [ -z "$SESSION_NAME" ]; then
        continue
    fi
    
    if [ "$IS_ATTACHED" = "0" ] && [ "$SESSION_NAME" != "parking" ] && [ "$SESSION_NAME" != "background" ]; then
        # Session is detached (but not parking or background), enable activity monitoring for all windows in this session
        WINDOWS=$($TMUX_BIN list-windows -t "$SESSION_NAME" -F "#{window_index}" 2>/dev/null)
        for WINDOW in $WINDOWS; do
            $TMUX_BIN set-window-option -t "$SESSION_NAME:$WINDOW" monitor-activity on 2>/dev/null
        done
    elif [ "$IS_ATTACHED" = "1" ] && [ "$SESSION_NAME" != "$CURRENT_SESSION" ]; then
        # Session is attached but not the current one (multiple clients), disable monitoring
        WINDOWS=$($TMUX_BIN list-windows -t "$SESSION_NAME" -F "#{window_index}" 2>/dev/null)
        for WINDOW in $WINDOWS; do
            $TMUX_BIN set-window-option -t "$SESSION_NAME:$WINDOW" monitor-activity off 2>/dev/null
        done
    fi

    # Ensure parking and background sessions have monitoring off
    if [ "$SESSION_NAME" = "parking" ] || [ "$SESSION_NAME" = "background" ]; then
        WINDOWS=$($TMUX_BIN list-windows -t "$SESSION_NAME" -F "#{window_index}" 2>/dev/null)
        for WINDOW in $WINDOWS; do
            $TMUX_BIN set-window-option -t "$SESSION_NAME:$WINDOW" monitor-activity off 2>/dev/null
            $TMUX_BIN set-window-option -t "$SESSION_NAME:$WINDOW" monitor-silence 0 2>/dev/null
        done
    fi
done <<< "$ALL_SESSIONS"

# Disable monitoring for current session (we're viewing it)
if [ -n "$CURRENT_SESSION" ]; then
    WINDOWS=$($TMUX_BIN list-windows -t "$CURRENT_SESSION" -F "#{window_index}" 2>/dev/null)
    for WINDOW in $WINDOWS; do
        $TMUX_BIN set-window-option -t "$CURRENT_SESSION:$WINDOW" monitor-activity off 2>/dev/null
        # Remove activity-action for current session (no notifications needed)
        $TMUX_BIN set-window-option -t "$CURRENT_SESSION:$WINDOW" activity-action none 2>/dev/null
    done
fi

