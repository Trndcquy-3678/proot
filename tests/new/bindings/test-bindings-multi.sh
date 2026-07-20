#!/bin/sh
# Test: Multiple bindings
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require mcookie "mcookie not found"

# Create test files
TEST_FILE1=$(tmpdir "file1")
TEST_FILE2=$(tmpdir "file2")
echo "content1" > "$TEST_FILE1"
echo "content2" > "$TEST_FILE2"

# Test 1: Multiple bindings work
RESULT=$(${PROOT} -b "$TEST_FILE1":/test1 -b "$TEST_FILE2":/test2 cat /test1 2>/dev/null)
is "$RESULT" "content1" "first binding works"

# Test 2: Second binding works
RESULT=$(${PROOT} -b "$TEST_FILE1":/test1 -b "$TEST_FILE2":/test2 cat /test2 2>/dev/null)
is "$RESULT" "content2" "second binding works"

# Cleanup
rm -f "$TEST_FILE1" "$TEST_FILE2"
plan 2
