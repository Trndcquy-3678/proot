#!/bin/sh
# Test: Fake ID0 (fake root)
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require id "id not found"

# Test 1: -i 123:456 sets UID/GID
RESULT=$(${PROOT} -i 123:456 id -u 2>/dev/null)
is "$RESULT" "123" "-i 123:456 sets UID"

# Test 2: -i 123:456 sets GID
RESULT=$(${PROOT} -i 123:456 id -g 2>/dev/null)
is "$RESULT" "456" "-i 123:456 sets GID"
plan 2
