#!/bin/sh
# Test: CWD with binding and -w flag
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require mcookie "mcookie not found"
require mkdir "mkdir not found"
require bash "bash not found"
require grep "grep not found"
require rm "rm not found"

# Create test directory
TEST_DIR=$(tmpdir "cwd-bind-test")
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Test 1: CWD with binding and -w works
RESULT=$(${PROOT} -b "${PWD}:/foo" -w /foo bash -c 'pwd' 2>/dev/null)
like "$RESULT" "^/foo$" "CWD with binding and -w works"

# Cleanup
cd /
rm -rf "$TEST_DIR"
plan 1
