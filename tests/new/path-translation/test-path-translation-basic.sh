#!/bin/sh
# Test: Path translation
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require_helper true
require mcookie "mcookie not found"

# Create test file
TEST_FILE=$(tmpdir "testfile")
echo "hello" > "$TEST_FILE"

# Test 1: Binding makes file visible at guest path
RESULT=$(${PROOT} -b "$TEST_FILE":/mounted cat /mounted 2>/dev/null)
is "$RESULT" "hello" "binding makes file visible at guest path"

# Test 2: Original path still accessible (bind is additive, like mount --bind)
RESULT=$(${PROOT} -b "$TEST_FILE":/mounted cat "$TEST_FILE" 2>/dev/null)
is "$RESULT" "hello" "original path still accessible after bind"

# Cleanup
rm -f "$TEST_FILE"
plan 2
