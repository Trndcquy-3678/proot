#!/bin/sh
# Test: Basic PRoot functionality
. "$(dirname "$0")/../../helpers.sh"


# Skip if proot not built
skip_if [ ! -x "${PROOT}" ] "proot not built"

# Skip if helpers not built
require_helper true || return 0

# Test 1: Basic execution
is_ok "basic execution works" "${PROOT} -r ${ROOTFS} /bin/true"

# Test 2: Root directory
is_ok "root directory exists" "[ -d '${ROOTFS}' ]"

# Test 3: Helper binary exists
is_ok "helper binary exists" "[ -x '${ROOTFS_BIN}/true' ]"
plan 3
