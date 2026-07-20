#!/bin/sh
# Test: /proc filesystem
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require readlink
require cat

# Test 1: /proc/self/exe resolves to a binary inside proot
RESULT=$(${PROOT} readlink /proc/self/exe 2>/dev/null)
like "$RESULT" "/proc/self/exe" "/proc/self/exe resolves inside proot"

# Test 2: /proc/self/cmdline works inside proot
RESULT=$(${PROOT} cat /proc/self/cmdline 2>/dev/null | tr '\0' ' ')
like "$RESULT" "cat" "/proc/self/cmdline contains command"
plan 2
