#!/bin/sh
# Format: parent/current|subdir [activity]
# Activity indicators (tmux monitor-activity/monitor-silence):
#   🌟 = has activity (output detected)
#   💤 = silent (no output for threshold seconds)
#   👂 = activity monitoring enabled
#   🎧 = silence monitoring enabled
#   (none) = no monitoring

pane_path="$1"
activity_flag="$2"
silence_flag="$3"
window_index="$4"

cd "$pane_path" 2>/dev/null || exit 0

# Get monitor settings from tmux window options (for this specific window)
if [ -n "$window_index" ]; then
    monitor_activity=$(tmux show-window-options -t "$window_index" -v monitor-activity 2>/dev/null || echo "off")
    monitor_silence=$(tmux show-window-options -t "$window_index" -v monitor-silence 2>/dev/null || echo "0")
else
    monitor_activity=$(tmux show-window-options -v monitor-activity 2>/dev/null || echo "off")
    monitor_silence=$(tmux show-window-options -v monitor-silence 2>/dev/null || echo "0")
fi

# Function to get activity indicator based on tmux monitor-activity/silence flags
get_activity_indicator() {
    indicator=""

    # Activity monitor indicator
    if [ "$activity_flag" = "1" ]; then
        # Activity detected - show alert
        indicator="$indicator 🌟"
    elif [ "$monitor_activity" != "off" ]; then
        # Activity monitoring on (listening)
        indicator="$indicator 👂"
    fi

    # Inactivity/Silence monitor indicator
    if [ "$silence_flag" = "1" ]; then
        # Silence detected - show alert
        indicator="$indicator 💤"
    elif [ "$monitor_silence" != "0" ]; then
        # Silence monitoring on (listening)
        indicator="$indicator 🎧"
    fi

    # Output the indicator (trimmed of leading space)
    echo "$indicator" | awk '{$1=$1;print}'
}

# Check if we're in a repository directory (without using git commands)
is_in_repo() {
    if [ -d .git ] || [ -f .git ]; then
        return 0
    fi
    return 1
}

# Find repository root by looking for .git
find_repo_root() {
    local current="$1"
    while [ "$current" != "/" ]; do
        if [ -d "$current/.git" ] || [ -f "$current/.git" ]; then
            echo "$current"
            return 0
        fi
        current=$(dirname "$current")
    done
    return 1
}

# Get meaningful directory name
get_meaningful_dir() {
    local path="$1"
    local repo_root="$2"

    # Remove repo root from path to get relative path
    relative_path="${path#$repo_root}"
    relative_path="${relative_path#/}"  # Remove leading slash

    # If at repo root
    if [ -z "$relative_path" ]; then
        echo ""
        return
    fi

    # Check for services/*/
    if echo "$relative_path" | grep -q "^services/"; then
        echo "$relative_path" | sed 's|^services/\([^/]*\).*|\1|'
        return
    fi

    # Check for packages/*/
    if echo "$relative_path" | grep -q "^packages/"; then
        echo "$relative_path" | sed 's|^packages/\([^/]*\).*|\1|'
        return
    fi

    # For other paths, get first directory after repo root
    echo "$relative_path" | cut -d'/' -f1
}

# Get activity indicator
activity=$(get_activity_indicator)

# Check if we're in a repository
if is_in_repo; then
    repo_root=$(find_repo_root "$pane_path")
    repo=$(basename "$repo_root")

    # Get meaningful directory name
    meaningful_dir=$(get_meaningful_dir "$pane_path" "$repo_root")

    # Format output based on location
    if [ -z "$meaningful_dir" ]; then
        # At repo root
        echo "$repo$activity"
    else
        # In subdir
        echo "$repo|$meaningful_dir$activity"
    fi
else
    # Not in a repo, show parent/current
    parent=$(basename "$(dirname "$pane_path")")
    current=$(basename "$pane_path")
    echo "$parent/$current$activity"
fi
