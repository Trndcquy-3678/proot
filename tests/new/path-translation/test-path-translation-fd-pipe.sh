#!/bin/sh
# Test: Pipe FDs work with /proc/self/fd binding
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require bash "bash not found"
require mcookie "mcookie not found"
skip_if [ ! -e /proc/self/fd/0 ] "/proc/self/fd/0 not available"

# Test 1: Process substitution doesn't produce "Broken pipe"
ERR=$(tmpdir "fd-pipe-test.err")
${PROOT} -b /proc/self/fd:/dev/fd bash -c 'echo <(echo a)' 2>"${ERR}"
STATUS=$?

if grep -q "Broken pipe" "${ERR}"; then
    fail "process substitution produces Broken pipe"
else
    ok "process substitution works without Broken pipe"
fi

# Cleanup
rm -f "${ERR}"
plan 1
