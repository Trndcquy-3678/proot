#!/bin/sh
# Test: /proc filesystem
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require_helper true

# Test 1: /proc/self/exe exists
RESULT=$(${PROOT} -r ${ROOTFS} readlink /proc/self/exe 2>/dev/null)
like "$RESULT" "true" "/proc/self/exe points to binary"

# Test 2: /proc/self/cmdline works
RESULT=$(${PROOT} -r ${ROOTFS} cat /proc/self/cmdline 2>/dev/null | tr '\0' ' ')
like "$RESULT" "cat" "/proc/self/cmdline contains command"
plan 2
