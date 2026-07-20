#!/bin/sh
# Test: rmdir(".") works
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require mcookie "mcookie not found"
require rmdir "rmdir not found"
require mkdir "mkdir not found"

# Create test directory
TEST_DIR=$(tmpdir "rmdir-test")
mkdir -p "$TEST_DIR"

# Test 1: rmdir(".") must fail
if ${PROOT} rmdir "${TEST_DIR}/." 2>/dev/null; then
    fail "rmdir('.') should fail"
else
    ok "rmdir('.') fails as expected"
fi

# Test 2: rmdir("./") must fail
if ${PROOT} rmdir "${TEST_DIR}/./" 2>/dev/null; then
    fail "rmdir('./') should fail"
else
    ok "rmdir('./') fails as expected"
fi

# Test 3: rmdir() on directory works
exit_code=0
${PROOT} rmdir "${TEST_DIR}" 2>/dev/null || exit_code=$?
is "$exit_code" "0" "rmdir() on directory works"
plan 3
