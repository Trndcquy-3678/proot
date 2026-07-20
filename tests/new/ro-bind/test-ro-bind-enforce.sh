#!/bin/sh
# Test: Read-only bindings
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require_helper true || return 0

# Create test directory
TEST_DIR=$(tmpdir "ro-test")
mkdir -p "$TEST_DIR"

# Test 1: Read-only binding prevents writes
RESULT=$(${PROOT} -b "$TEST_DIR":/test,ro sh -c 'touch /test/file 2>&1' 2>/dev/null)
like "$RESULT" "Read-only file system" "ro binding prevents writes"

# Test 2: Regular binding allows writes
${PROOT} -b "$TEST_DIR":/test sh -c 'touch /test/file' 2>/dev/null
file_exists "$TEST_DIR/file" "rw binding allows writes"

# Cleanup
rm -rf "$TEST_DIR"
plan 2
