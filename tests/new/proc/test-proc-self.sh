#!/bin/sh
# Test: /proc filesystem
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require readlink
require cat

# Test 1: /proc/self/exe resolves to a valid absolute path
RESULT=$(${PROOT} readlink /proc/self/exe 2>/dev/null)
like "$RESULT" '^/' "/proc/self/exe resolves to an absolute path"

# Test 2: /proc/self/cmdline is non-empty inside proot
RESULT=$(${PROOT} cat /proc/self/cmdline 2>/dev/null)
if [ -n "$RESULT" ]; then
    ok "/proc/self/cmdline is non-empty"
else
    fail "/proc/self/cmdline is non-empty"
fi
plan 2
