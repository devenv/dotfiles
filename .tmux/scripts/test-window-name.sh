#!/bin/bash

# Test script for window-name.sh
# Usage: ./test-window-name.sh

TEST_DIR="/tmp/test-window-name"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"
git init -q
echo "test" > test.txt
git add . && git commit -q -m "initial"

WINDOW_NAME_SCRIPT="/Users/devenv/.tmux/scripts/window-name.sh"

# Function to run a test
run_test() {
    local name="$1"
    local path="$2"
    local activity_flag="$3"
    local silence_flag="$4"
    local monitor_activity="$5"
    local monitor_silence="$6"

    echo "Test: $name"
    echo "  Params: activity_flag=$activity_flag silence_flag=$silence_flag monitor_activity=$monitor_activity monitor_silence=$monitor_silence"
    local result=$("$WINDOW_NAME_SCRIPT" "$path" "$activity_flag" "$silence_flag" "$monitor_activity" "$monitor_silence")
    echo "  Result: $result"
    echo ""
}

echo "====== Window Name Tests ======"
echo ""

# Test 1: No monitoring
run_test "No monitoring" "$TEST_DIR" "0" "0" "off" "0"

# Test 2: Activity monitoring on (no activity)
run_test "Activity monitoring on (no activity)" "$TEST_DIR" "0" "0" "on" "0"

# Test 3: Activity detected
run_test "Activity detected" "$TEST_DIR" "1" "0" "on" "0"

# Test 4: Silence monitoring on (no silence)
run_test "Silence monitoring on (no silence)" "$TEST_DIR" "0" "0" "off" "60"

# Test 5: Silence detected
run_test "Silence detected" "$TEST_DIR" "0" "1" "off" "60"

# Test 6: Both monitoring on
run_test "Both monitoring on" "$TEST_DIR" "0" "0" "on" "60"

# Test 7: Both detected
run_test "Both detected" "$TEST_DIR" "1" "1" "on" "60"

# Test 8: With dirty state
echo "test2" >> test.txt
run_test "With uncommitted changes + activity monitoring" "$TEST_DIR" "0" "0" "on" "0"

# Cleanup
cd /
rm -rf "$TEST_DIR"
