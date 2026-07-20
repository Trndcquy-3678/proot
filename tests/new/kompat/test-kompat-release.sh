#!/bin/sh
# Test: Kernel compatibility
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require uname "uname not found"

# Test 1: -k sets kernel release
RESULT=$(${PROOT} -k 5.10.0 uname -r 2>/dev/null)
is "$RESULT" "5.10.0" "-k sets kernel release"

# Test 2: Custom kernel release
RESULT=$(${PROOT} -k 4.19.0 uname -r 2>/dev/null)
is "$RESULT" "4.19.0" "custom kernel release works"
plan 2
