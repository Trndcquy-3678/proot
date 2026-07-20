#!/bin/sh
# Test: Directory listing through binding
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require ls "ls not found"

# Test 1: Directory listing through binding works
RESULT=$(${PROOT} -b /etc:/x ls /x 2>/dev/null)
like "$RESULT" "passwd\|group\|hosts" "directory listing through binding works"
plan 1
