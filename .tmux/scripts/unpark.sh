#!/bin/bash
LOG_FILE=~/.tmux/scripts/unpark.log
TMUX_BIN=/opt/homebrew/bin/tmux

echo "Script started" >> $LOG_FILE

# Get current session name
CURRENT_SESSION=$($TMUX_BIN display-message -p '#{session_name}' 2>>$LOG_FILE)
echo "Current session: $CURRENT_SESSION" >> $LOG_FILE

# Check if parking session exists, if not create one
if ! $TMUX_BIN has-session -t parking 2>/dev/null; then
    echo "Parking session does not exist, creating one" >> $LOG_FILE
    $TMUX_BIN new-session -d -s parking 2>>$LOG_FILE
fi

# If we're in parking session, move all windows back to session 0
if [ "$CURRENT_SESSION" = "parking" ]; then
    echo "Currently in parking session, moving windows to session 0" >> $LOG_FILE

    # Ensure session 0 exists
    if ! $TMUX_BIN has-session -t 0 2>/dev/null; then
        $TMUX_BIN new-session -d -s 0 2>>$LOG_FILE
    fi

    # Get list of windows in parking session
    WINDOW_DATA=$($TMUX_BIN list-windows -t parking -F '#{window_id}:#{window_index}' 2>>$LOG_FILE)
    echo "Windows in parking: $WINDOW_DATA" >> $LOG_FILE

    if [ -z "$WINDOW_DATA" ]; then
        echo "No windows in parking session, nothing to do" >> $LOG_FILE
        echo "Script finished (no windows to move)" >> $LOG_FILE
        exit 0
    fi

    # Store first window to select after moving
    FIRST_WINDOW_PAIR=$(echo "$WINDOW_DATA" | sort -t: -k2 -n | head -1)
    FIRST_WINDOW_ID=$(echo "$FIRST_WINDOW_PAIR" | cut -d: -f1)
    FIRST_WINDOW_INDEX=$(echo "$FIRST_WINDOW_PAIR" | cut -d: -f2)

    # Move each window from parking to session 0 (append to the end)
    for WINDOW_PAIR in $(echo "$WINDOW_DATA" | sort -t: -k2 -n); do
        WINDOW_INDEX=$(echo "$WINDOW_PAIR" | cut -d: -f2)
        echo "Moving window parking:$WINDOW_INDEX to end of session 0" >> $LOG_FILE
        $TMUX_BIN move-window -s "parking:$WINDOW_INDEX" -t "0" 2>>$LOG_FILE
    done

    # Switch to session 0 and select first moved window
    $TMUX_BIN switch-client -t 0 2>>$LOG_FILE
    TARGET_WINDOW=$($TMUX_BIN list-windows -t "0" -F '#{window_index}:#{window_id}' 2>>$LOG_FILE | grep ":$FIRST_WINDOW_ID$" | cut -d: -f1)
    if [ -n "$TARGET_WINDOW" ]; then
        echo "Selecting window $TARGET_WINDOW in session 0" >> $LOG_FILE
        $TMUX_BIN select-window -t "0:$TARGET_WINDOW" 2>>$LOG_FILE
    fi

    echo "Script finished (moved windows to session 0)" >> $LOG_FILE
    exit 0
fi

# We're in session 0 (or another session), so switch to parking session
echo "Switching to parking session" >> $LOG_FILE
$TMUX_BIN switch-client -t parking 2>>$LOG_FILE
if [ $? -eq 0 ]; then
    echo "Successfully switched to parking session" >> $LOG_FILE
else
    echo "Failed to switch to parking session, error code: $?" >> $LOG_FILE
fi

echo "Script finished" >> $LOG_FILE
