#!/bin/bash
# Notify when there's activity in the "background" session

TMUX_BIN=/opt/homebrew/bin/tmux
SESSION_NAME="$1"
WINDOW_NAME="$2"
PANE_TITLE="$3"

# Only notify for the "background" session
if [ "$SESSION_NAME" != "background" ]; then
    exit 0
fi

# Only notify if session is detached
IS_ATTACHED=$($TMUX_BIN list-sessions -F "#{session_name}:#{session_attached}" 2>/dev/null | grep "^${SESSION_NAME}:" | cut -d: -f2)

if [ "$IS_ATTACHED" = "1" ]; then
    # Session is attached, don't notify
    exit 0
fi

# Build notification message
MESSAGE="Activity in background session"
if [ -n "$WINDOW_NAME" ]; then
    MESSAGE="${MESSAGE} - ${WINDOW_NAME}"
fi

# Try different notification methods
if command -v terminal-notifier >/dev/null 2>&1; then
    # macOS with terminal-notifier
    terminal-notifier -title "Tmux Activity" -message "$MESSAGE" -sound default 2>/dev/null
elif command -v osascript >/dev/null 2>&1; then
    # macOS with osascript (built-in)
    osascript -e "display notification \"$MESSAGE\" with title \"Tmux Activity\"" 2>/dev/null
elif command -v notify-send >/dev/null 2>&1; then
    # Linux with notify-send
    notify-send "Tmux Activity" "$MESSAGE" 2>/dev/null
fi
