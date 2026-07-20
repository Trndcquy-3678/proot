#!/bin/sh
# Test: Current working directory
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require_helper true || return 0
require mcookie "mcookie not found"

# Create test directory
TEST_DIR=$(tmpdir "cwd-test")
mkdir -p "$TEST_DIR"

# Test 1: -w sets working directory
RESULT=$(${PROOT} -w "$TEST_DIR" pwd 2>/dev/null)
is "$RESULT" "$TEST_DIR" "-w sets working directory"

# Test 2: pwd -P returns physical path
RESULT=$(${PROOT} -w "$TEST_DIR" pwd -P 2>/dev/null)
is "$RESULT" "$TEST_DIR" "pwd -P works"

# Cleanup
rm -rf "$TEST_DIR"
plan 2
