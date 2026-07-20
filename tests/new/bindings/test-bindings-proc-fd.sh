#!/bin/sh
# Test: /proc/self/fd binding works
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require mcookie "mcookie not found"
require cat "cat not found"
require grep "grep not found"
skip_if [ ! -e /proc/self/fd/0 ] "/proc/self/fd/0 not available"

# Create test file
TEST_FILE=$(tmpdir "proc-fd-test")
echo "hello" > "$TEST_FILE"

# Test 1: /proc/self/fd binding works
RESULT=$(${PROOT} -b /proc/self/fd:/dev/fd sh -c "cat /dev/fd/3 3</dev/stdin" < "$TEST_FILE" 2>/dev/null)
like "$RESULT" "^hello$" "/proc/self/fd binding works"

# Cleanup
rm -f "$TEST_FILE"
plan 1
