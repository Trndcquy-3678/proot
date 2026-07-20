#!/bin/sh
# Test: Path translation
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require_helper true || return 0
require mcookie "mcookie not found"

# Create test file
TEST_FILE=$(tmpdir "testfile")
echo "hello" > "$TEST_FILE"

# Test 1: Binding translates path
RESULT=$(${PROOT} -b "$TEST_FILE":/mounted cat /mounted 2>/dev/null)
is "$RESULT" "hello" "path translation works"

# Test 2: Original path not visible
RESULT=$(${PROOT} -b "$TEST_FILE":/mounted cat "$TEST_FILE" 2>/dev/null)
like "$RESULT" "No such file or directory" "original path not visible"

# Cleanup
rm -f "$TEST_FILE"
plan 2
