#!/bin/sh
# Test: /proc/self/exe for foreign binaries
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require true "true not found"
require realpath "realpath not found"
require grep "grep not found"
require env "env not found"
skip_if [ ! -x "${ROOTFS_BIN}/puts_proc_self_exe" ] "puts_proc_self_exe helper not built"

# Get path to true binary
TRUE=$(realpath "$(which true)")

# Test 1: /proc/self/exe reports correct path for foreign binary
RESULT=$(env PROOT_FORCE_FOREIGN_BINARY=1 ${PROOT} -q "${ROOTFS}/bin/puts_proc_self_exe" "$TRUE" 2>/dev/null)
like "$RESULT" "^${TRUE}$" "/proc/self/exe reports correct path for foreign binary"
plan 1
