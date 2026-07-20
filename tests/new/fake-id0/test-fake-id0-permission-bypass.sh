#!/bin/sh
# Test: Fake ID0 permission bypass
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require mcookie "mcookie not found"
require id "id not found"
require mkdir "mkdir not found"
require touch "touch not found"
require chmod "chmod not found"
require stat "stat not found"
require grep "grep not found"

# Skip if running as root
skip_if [ "$(id -u)" -eq 0 ] "running as root"

# Create test directory
TEST_DIR=$(tmpdir "fake-id0-perm-test")
mkdir -p "$TEST_DIR/foo"
chmod a-rwx "$TEST_DIR/foo"
chmod a-rwx "$TEST_DIR"

# Test 1: Without -0, cannot touch in restricted dir
if ${PROOT} touch "$TEST_DIR/foo/bar" 2>/dev/null; then
    fail "without -0, should fail but succeeded"
else
    ok "without -0, cannot touch in restricted dir"
fi

# Test 2: With -i 123:456, still cannot touch
if ${PROOT} -i 123:456 touch "$TEST_DIR/foo/bar" 2>/dev/null; then
    fail "with -i 123:456, should fail but succeeded"
else
    ok "with -i 123:456, still cannot touch"
fi

# Test 3: With -0, can touch in restricted dir
exit_code=0
${PROOT} -0 touch "$TEST_DIR/foo/bar" 2>/dev/null || exit_code=$?
is "$exit_code" "0" "with -0, can touch in restricted dir"

# Cleanup
chmod -R a+rwx "$TEST_DIR"
rm -rf "$TEST_DIR"
plan 3
